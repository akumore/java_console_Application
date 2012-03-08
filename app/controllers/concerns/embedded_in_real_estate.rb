module EmbeddedInRealEstate
  extend ActiveSupport::Concern

  included do
    before_filter :load_real_estate
  end

  def load_real_estate
    @real_estate = RealEstate.find(params[:real_estate_id])
  end

  def redirect_to_step name
    flash.now[:success] = "#{controller_name.singularize.classify.constantize.model_name.human} erfolgreich gespeichert."
    if @real_estate.send(name).present?
      redirect_to send("edit_cms_real_estate_#{name.singularize}_path", @real_estate)
    else
      redirect_to send("new_cms_real_estate_#{name.singularize}_path", @real_estate)
    end
  end
end