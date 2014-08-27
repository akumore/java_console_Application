class Cms::RealEstatesController < Cms::SecuredController
  load_and_authorize_resource :except => [:index, :show, :new, :create, :copy]

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to [:cms, @real_estate], :alert => exception.message
  end

  def index
    begin
      Mongoid.identity_map_enabled = true
      Mongoid::IdentityMap.clear
      case params[:filter]
      when RealEstate::STATE_EDITING
        @real_estates = RealEstate.editing
      when RealEstate::STATE_PUBLISHED
        @real_estates = RealEstate.published
      when RealEstate::STATE_ARCHIVED
        @real_estates = RealEstate.archived
      else
        @real_estates = RealEstate.without_archived
      end
      @real_estates = RealEstateDecorator.decorate(@real_estates.includes(:category, :contact).default_order)
      respond_with @real_estates
    ensure
      Mongoid.identity_map_enabled = false
      Mongoid::IdentityMap.clear
    end
  end

  def show
    @real_estate = RealEstateDecorator.decorate(RealEstate.find(params[:id]))
    respond_with @real_estate
  end

  def new
    @real_estate = RealEstate.new(:reference => Reference.new)
    respond_with @real_estate
  end

  def edit
  end

  def create
    real_estate_params = params[:real_estate]
    real_estate_params.delete(:channels_defined)
    real_estate_params.merge!(:creator => current_user)

    @real_estate = RealEstate.new(params[:real_estate])

    if @real_estate.save
      redirect_to new_cms_real_estate_address_path(@real_estate)
    else
      render 'new'
    end
  end

  def update
    real_estate_params = params.fetch(:real_estate, {})
    real_estate_params.merge!(:editor => current_user) if save_last_editor?(real_estate_params[:state_event])

    if real_estate_params.delete(:channels_defined) && real_estate_params[:channels].nil?
      real_estate_params[:channels] = []
    end

    if real_estate_params[:state_event].to_s == 'unpublish_it'
      @real_estate.update_attribute(:state, RealEstate::STATE_EDITING ) # ensure the real estate can be edited again, even if it is invalid at the moment
      real_estate_params.delete(:state_event)
    end

    @real_estate.attributes = real_estate_params
    if @real_estate.changed.include? 'language'
      InformationDecorator.new(@real_estate.information).update_characteristics if @real_estate.information
      FigureDecorator.new(@real_estate.figure).update_characteristics if @real_estate.figure
    end

    if @real_estate.save
      notify_users(real_estate_params[:state_event], @real_estate)

      respond_to do |format|
        format.js { flash.now[:success] = t('cms.real_estates.update.sorted.success') }
        format.html do
          if @real_estate.published? || (@real_estate.in_review? && cannot?(:publish_it, @real_estate)) || @real_estate.archived?
            redirect_to [:cms, @real_estate]
          else
            if @real_estate.address.present?
              redirect_to edit_cms_real_estate_address_path(@real_estate)
            else
              redirect_to new_cms_real_estate_address_path(@real_estate)
            end
          end
        end
      end
    else
      render 'edit'
    end
  end

  def destroy
    @real_estate.destroy
    redirect_to(cms_real_estates_url, :notice => t('cms.real_estates.index.destroyed', :title => @real_estate.title))
  end

  def copy
    @real_estate = RealEstate.find(params[:id])
    @copy_of_real_estate = RealEstate.copy!(@real_estate)
    redirect_to edit_cms_real_estate_path(@copy_of_real_estate)
  end

  def editing_model
    if @real_estate.respond_to?(:model)
      @real_estate.model
    else
      @real_estate
    end
  end

  private

  def notify_users(transition, real_estate)
    if transition.present?
      if transition == 'review_it'
        RealEstateStateMailer.review_notification(real_estate).deliver
      elsif transition == 'reject_it'
        RealEstateStateMailer.reject_notification(real_estate, current_user).deliver
      end
    end
  end

  def save_last_editor?(transition)
    if current_user.editor?
      true
    else
      if transition.present?
        %w(review_it reject_it publish_it unpublish_it archive_it reactivate_it).include?(transition) ? false : true
      else
        true
      end
    end
  end
end
