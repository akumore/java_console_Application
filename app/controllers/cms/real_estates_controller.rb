class Cms::RealEstatesController < Cms::SecuredController
  load_and_authorize_resource :except => [:index, :show, :new, :create, :copy]

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to [:cms, @real_estate], :alert => exception.message
  end

  def index
    @real_estates = RealEstateDecorator.decorate(RealEstate.all)
    respond_with @real_estates
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

    if @real_estate.update_attributes(real_estate_params)
      notify_users(real_estate_params[:state_event], @real_estate)

      respond_to do |format|
        format.js { flash.now[:success] = t('cms.real_estates.update.sorted.success') }
        format.html do
          if @real_estate.published? || @real_estate.in_review? && cannot?(:publish_it, @real_estate)
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
    @real_estate
  end

  def field_access
    @field_access ||= FieldAccess.new(@real_estate.offer, @real_estate.utilization, FieldAccess.cms_blacklist)
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
        %w(review_it reject_it publish_it unpublish_it).include?(transition) ? false : true
      else
        true
      end
    end
  end
end
