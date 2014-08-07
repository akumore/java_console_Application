class HandoutsController < ApplicationController
  layout 'handout'
  include RealEstatesHelper

  caches_page :show

  def show
    @real_estate = RealEstateDecorator.new accessible_real_estates.print_channel.find(params[:real_estate_id])

    respond_to do |format|
      format.html { render :show }

      format.pdf do
        send_data @real_estate.handout.to_pdf,
          filename: "#{@real_estate.handout.filename}.pdf",
          type: 'application/pdf',
          disposition: 'inline'
      end
    end
  end

  def deprecated_route
    redirect_to real_estate_handout_path(
      :real_estate_id => params[:real_estate_id],
      :format => :pdf
    )
  end

  def footer
    render :layout => false
  end
end
