class HandoutsController < ApplicationController
  layout 'handout'

  caches_page :footer, :show

  def show
    @real_estate = RealEstateDecorator.new RealEstate.published.print_channel.find(params[:real_estate_id])
    raise 'Real Estate must be for rent' if @real_estate.for_sale?

    respond_to do |format|
      format.html { render :show }
      format.pdf { render :text => PDFKit.new(
        real_estate_object_documentation_url(
          :real_estate_id => @real_estate.id,
          :format => :html,
          :name => @real_estate.object_documentation_title
        )
      ).to_pdf }
    end
  end

  def footer
    render :layout => false
  end
end
