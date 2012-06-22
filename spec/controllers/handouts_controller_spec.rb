# encoding: utf-8
require 'spec_helper'

describe HandoutsController do
  let :real_estate_for_sale do
    Fabricate :published_real_estate, :category => Fabricate(:category), :offer =>  RealEstate::OFFER_FOR_SALE, :channels => [RealEstate::PRINT_CHANNEL]
  end

  let :real_estate_for_rent do
    Fabricate :published_real_estate, :category => Fabricate(:category), :offer =>  RealEstate::OFFER_FOR_RENT, :channels => [RealEstate::PRINT_CHANNEL]
  end

  describe 'minidoku/handout' do
    context 'when the real estate is for sale' do
      it 'is not accessible' do
        expect { get :show, :real_estate_id => real_estate_for_sale.id, :format => :pdf, :locale => :de }.to raise_error
      end
    end

    context 'when the real estate is for rent' do
      before do
        PDFKit.should_receive(:new).with("http://test.host/de/real_estates/#{real_estate_for_rent.id}/Objektdokumentation-#{real_estate_for_rent.title.parameterize}.html").and_return mock(PDFKit, :to_pdf => 'yes, this is pdf')
      end

      it 'is accessible' do
        get :show, :real_estate_id => real_estate_for_rent.id, :format => :pdf, :locale => :de
        response.should be_success
      end
    end
  end

end
