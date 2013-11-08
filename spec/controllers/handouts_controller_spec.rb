# encoding: utf-8
require 'spec_helper'

describe HandoutsController do
  let :real_estate_for_sale do
    Fabricate(:published_real_estate, 
              :category => Fabricate(:category),
              :offer =>  Offer::SALE,
              :channels => [RealEstate::PRINT_CHANNEL]
             )
  end

  let :real_estate_for_rent do
    Fabricate(:published_real_estate, 
              :category => Fabricate(:category), 
              :offer =>  Offer::RENT, 
              :channels => [RealEstate::PRINT_CHANNEL],
              :print_channel_method => RealEstate::PRINT_CHANNEL_METHOD_PDF_DOWNLOAD
             )
  end

  describe 'minidoku/handout' do
    context 'when the real estate is for sale' do
      it 'is not accessible' do
        expect { get :show, :real_estate_id => real_estate_for_sale.id, :format => :pdf, :locale => :de }.to raise_error
      end
    end

    context 'when the real estate is for rent' do
      it 'is accessible' do
        url = "http://test.host/de/real_estates/#{real_estate_for_rent.id}/handout.html"
        Rails.application.routes.url_helpers.should_receive(:real_estate_handout_url).and_return(url)
        PDFKit.should_receive(:new).with(url).and_return mock(PDFKit, :to_pdf => 'yes, this is pdf')
        get :show, :real_estate_id => real_estate_for_rent.id, :format => :pdf, :locale => :de
        response.should be_success
      end

      context 'when the real estate has order handout configured' do
        it 'is not accessible' do
          real_estate_for_rent.update_attribute(:print_channel_method, RealEstate::PRINT_CHANNEL_METHOD_ORDER)
          expect { get :show, :real_estate_id => real_estate_for_rent.id, :format => :html, :locale => :de }.to raise_error
        end
      end
    end
  end

end
