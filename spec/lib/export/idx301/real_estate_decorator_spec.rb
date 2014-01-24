# encoding: utf-8

require 'spec_helper'

describe Export::Idx301::RealEstateDecorator do
  ## workaround for issue: https://github.com/jcasimir/draper/issues/60
  include Rails.application.routes.url_helpers
  before :all do
    c = ApplicationController.new
    c.request = ActionDispatch::TestRequest.new
    c.set_current_view_context
  end
  ## end of workaround

  let :account do
    Account.new(:provider => 'test')
  end

  describe 'an invalid real estate' do
    before :each do
      real_estate = Fabricate(:published_real_estate,
        :category => Fabricate(:category)
      )
      @decorator = Export::Idx301::RealEstateDecorator.new(real_estate, account, {
        :images => [],
        :movies => [],
        :documents => []
      })
    end

    [
      :version,
      :sender_id,
      :object_category,
      :object_type,
      :offer_type,
      :ref_property,
      :ref_house,
      :ref_object,
      :object_street,
      :object_zip,
      :object_city,
      :object_state,
      :object_country,
      :region,
      :object_situation,
      :available_from,
      :object_title,
      :object_description,
      :selling_price,
      :rent_net,
      :rent_extra,
      :price_unit,
      :currency,
      :gross_premium,
      :floor,
      :number_of_rooms,
      :number_of_apartments,
      :surface_living,
      :surface_property,
      :surface_usable,
      :volume,
      :year_built,
      :prop_view,
      :prop_fireplace,
      :prop_cabletv,
      :prop_elevator,
      :prop_child_friendly,
      :prop_parking,
      :prop_garage,
      :prop_balcony,
      :prop_roof_floor,
      :distance_public_transport,
      :distance_shop,
      :distance_kindergarten,
      :distance_school1,
      :distance_school2,
      :picture_1_filename,
      :picture_2_filename,
      :picture_3_filename,
      :picture_4_filename,
      :picture_5_filename,
      :picture_1_title,
      :picture_2_title,
      :picture_3_title,
      :picture_4_title,
      :picture_5_title,
      :picture_1_description,
      :picture_2_description,
      :picture_3_description,
      :picture_4_description,
      :picture_5_description,
      :movie_filename,
      :movie_title,
      :movie_description,
      :document_filename,
      :document_title,
      :document_description,
      :url,
      :agency_id,
      :agency_name,
      :agency_name_2,
      :agency_reference,
      :agency_street,
      :agency_zip,
      :agency_city,
      :agency_country,
      :agency_phone,
      :agency_mobile,
      :agency_fax,
      :agency_email,
      :agency_logo,
      :visit_name,
      :visit_phone,
      :visit_email,
      :visit_remark,
      :publish_until,
      :destination,
      :picture_6_filename,
      :picture_7_filename,
      :picture_8_filename,
      :picture_9_filename,
      :picture_6_title,
      :picture_7_title,
      :picture_8_title,
      :picture_9_title,
      :picture_6_description,
      :picture_7_description,
      :picture_8_description,
      :picture_9_description,
      :picture_1_url,
      :picture_2_url,
      :picture_3_url,
      :picture_4_url,
      :picture_5_url,
      :picture_6_url,
      :picture_7_url,
      :picture_8_url,
      :picture_9_url,
      :distance_motorway,
      :ceiling_height,
      :hall_height,
      :maximal_floor_loading,
      :carrying_capacity_crane,
      :carrying_capacity_elevator,
      :isdn,
      :wheelchair_accessible,
      :animal_allowed,
      :ramp,
      :lifting_platform,
      :railway_terminal,
      :restrooms,
      :water_supply,
      :sewage_supply,
      :power_supply,
      :gas_supply,
      :municipal_info,
      :own_object_url,
      :billing_anrede,
      :billing_first_name,
      :billing_name,
      :billing_company,
      :billing_street,
      :billing_post_box,
      :billing_zip,
      :billing_place_name,
      :billing_land,
      :billing_phone_1,
      :billing_phone_2,
      :billing_mobile,
      :billing_language,
      :publishing_id,
      :delivery_id,
      :picture_10_filename,
      :picture_11_filename,
      :picture_12_filename,
      :picture_13_filename,
      :picture_10_title,
      :picture_11_title,
      :picture_12_title,
      :picture_13_title,
      :picture_10_description,
      :picture_11_description,
      :picture_12_description,
      :picture_13_description,
      :picture_10_url,
      :picture_11_url,
      :picture_12_url,
      :picture_13_url,
      :commission_sharing,
      :commission_own,
      :commission_partner,
      :agency_logo_2,
      :number_of_floors,
      :year_renovated,
      :flat_sharing_community,
      :corner_house,
      :middle_house,
      :building_land_connected,
      :gardenhouse,
      :raised_ground_floor,
      :new_building,
      :old_building,
      :under_building_laws,
      :under_roof,
      :swimmingpool,
      :minergie_general,
      :minergie_certified,
      :last_modified,
      :advertisement_id,
      :sparefield_1,
      :sparefield_2,
      :sparefield_3,
      :sparefield_4
    ].each do |accessor|
      it "calling #{accessor} doesnt raise an exception with invalid data" do
        expect { @decorator.send(accessor) }.to_not raise_error
      end
    end
  end

  describe '#to_a' do
    it 'has no newlines' do
      newline_string = "attribute\n\n\r with \nnewlines\n"
      real_estate_decorator = Export::Idx301::RealEstateDecorator.new(
        mock_model(RealEstate, :title => newline_string, :description => newline_string),
        account,
        {}
      )
      real_estate_decorator.stub(:allowed).and_return([:title, :description])
      real_estate_decorator.to_a.should be_all { |value| value.should == 'attribute with newlines'  }
    end
  end

  describe '#object_description' do
    it 'returns "-"" if theres no description present' do
      real_estate = Export::Idx301::RealEstateDecorator
        .new(
          mock_model(RealEstate, :description => ""),
          account,
          {}
        )
      expect(real_estate.object_description).to eq '-'
    end

    it 'retains newlines for homegate by converting them to br-Tags' do
      real_estate = Export::Idx301::RealEstateDecorator
        .new(
          mock_model(RealEstate, :description => "<p>It<br />breaks</p><p>into new lines</p>"),
          account,
          {}
        )
      expect(real_estate.object_description).to eq('It<br>breaks<br><br>into new lines')
    end

    it 'renders asteriks (*) into <li> bullet points' do
      real_estate = Export::Idx301::RealEstateDecorator
        .new(
          mock_model(RealEstate, :description => "<p>I<br />have</p><ul><li>one</li><li>two</li><li>three</li></ul><p>list items</p>"),
          account,
          {}
        )
      expect(real_estate.object_description).to eq('I<br>have<br><br><li>one</li><li>two</li><li>three</li><br>list items')
    end

    it 'remove double break after heading' do
      real_estate = Export::Idx301::RealEstateDecorator
        .new(
          mock_model(RealEstate, :description => "<h3>Vorteile</h3><ul><li>Maisonette-Wohnung</li><li>Bad und Waschturm</li></ul><p>Autoeinstellhalle kann dazugemietet werden.</p>"),
          account,
          {}
        )
      expect(real_estate.object_description).to eq("Vorteile<br><li>Maisonette-Wohnung</li><li>Bad und Waschturm</li><br>Autoeinstellhalle kann dazugemietet werden.")
    end

    context 'with immoscout as provider' do
      it 'maintains the ul tags' do
        real_estate = Export::Idx301::RealEstateDecorator
          .new(
            mock_model(RealEstate, :description => "<h3>Vorteile</h3><ul><li>Maisonette-Wohnung</li><li>Bad und Waschturm</li></ul><p>Autoeinstellhalle kann dazugemietet werden.</p>"),
            Account.new(:provider => Provider::IMMOSCOUT),
            {}
          )

        expect(real_estate.object_description).to eq("Vorteile<br><ul><li>Maisonette-Wohnung</li><li>Bad und Waschturm</li></ul><br>Autoeinstellhalle kann dazugemietet werden.")
      end
    end

    context 'with HTMLEntities' do
      it 'convert the HTMLEntities' do
        real_estate = Export::Idx301::RealEstateDecorator
          .new(
            mock_model(RealEstate, :description => "<h3>&Uuml;bersicht</h3><ul><li>Element mit &ouml;</li><li>Element mit &auml;</li><li>Element mit &uuml;</li></ul>"),
            account,
            {}
          )

        expect(real_estate.object_description).to eq("Übersicht<br><li>Element mit ö</li><li>Element mit ä</li><li>Element mit ü</li>")
      end
    end
  end

  describe '#available_from' do
    it 'returns the reference date of the real estate' do
      real_estate = Export::Idx301::RealEstateDecorator.new(
        mock_model(RealEstate, 
          pricing: mock_model(Pricing, 
            available_from: Date.parse('2012-01-01'),
            for_rent?: false,
            additional_costs_is_mandatory?: false,
            for_sale?: false
          )
        ),
        account,
        {}
      )

      expect(real_estate.available_from).to eq '01.01.2012'
    end
  end

  describe '#object_type' do
    it 'returns 5 for an underground_slot' do
      real_estate = Export::Idx301::RealEstateDecorator
        .new(
          mock_model(RealEstate, :category => mock_model(Category, :name => 'underground_slot')),
          account,
          {}
        )
      real_estate.stub!(:top_level_category_name).and_return('parking')
      real_estate.object_type.should == 5
    end
  end

  describe '#object_title' do
    context 'real estate is of utilization parking' do
      it 'returns the category label' do
        real_estate = Fabricate.build(:real_estate,
            :category => Fabricate.build(:category, :name => 'single_house', :label => 'Einfamilienhaus'),
            :title => 'Dummy Title',
            :utilization => Utilization::PARKING
          )
        decorator = Export::Idx301::RealEstateDecorator.new(real_estate, account, {})

        expect(decorator.object_title).to eq 'Einfamilienhaus'
      end

    end

    context 'real estate is not of utilization parking' do
      it 'returns the real estate title' do
        real_estate = Fabricate.build(:real_estate,
            :category => Fabricate.build(:category, :name => 'single_house', :label => 'Einfamilienhaus'),
            :title => 'Dummy Title',
            :utilization => Utilization::LIVING
          )
        decorator = Export::Idx301::RealEstateDecorator.new(real_estate, account, {})

        expect(decorator.object_title).to eq 'Dummy Title'
      end
    end
  end

  describe '#ceiling_height' do
    context 'for private use' do
      it 'has a value' do
        real_estate = Export::Idx301::RealEstateDecorator.new(
          mock_model(RealEstate,  :commercial_utilization? => false,
                                  :private_utilization? => true,
                                  :information => mock_model(Information, :ceiling_height => '2.50')
                                  ),
          account,
          {}
        )
        real_estate.ceiling_height.should == '2.50'
      end
    end

    context 'for commercial use' do
      it 'is empty' do
        real_estate = Export::Idx301::RealEstateDecorator.new(
          mock_model(RealEstate,  :commercial_utilization? => true,
                                  :private_utilization? => false,
                                  :information => mock_model(Information, :ceiling_height => '2.50')
                                  ),
          account,
          {}
        )
        real_estate.ceiling_height.should be_nil
      end
    end
  end

  describe '#hall_height' do
    context 'for commercial use' do
      it 'has a value' do
        real_estate = Export::Idx301::RealEstateDecorator.new(
          mock_model(RealEstate,  :commercial_utilization? => false,
                                  :private_utilization? => true,
                                  :information => mock_model(Information, :ceiling_height => '2.50')
                                  ),
          account,
          {}
        )
        real_estate.ceiling_height.should == '2.50'
      end
    end

    context 'for private use' do
      it 'is empty' do
        real_estate = Export::Idx301::RealEstateDecorator.new(
          mock_model(RealEstate,  :commercial_utilization? => true,
                                  :private_utilization? => false,
                                  :information => mock_model(Information, :ceiling_height => '2.50')
                                  ),
          account,
          {}
        )
        real_estate.ceiling_height.should be_nil
      end
    end
  end

  describe '#rent_net' do
    context 'with a price' do
      it 'returns the rounded price' do
        real_estate = Export::Idx301::RealEstateDecorator.new(
          mock_model(RealEstate, :pricing => mock_model(Pricing, :for_rent_netto => '2.50')),
          account,
          {}
        )
        real_estate.rent_net.should be(3)
      end
    end

    context 'without a price' do
      it 'returns nothing and is therefore "by request"' do
        real_estate = Export::Idx301::RealEstateDecorator.new(
          mock_model(RealEstate, :pricing => mock_model(Pricing, :for_rent_netto => '')),
          account,
          {}
        )
        real_estate.rent_net.should be_nil
      end
    end
  end

  describe '#rent_extra' do
    context 'with a price' do
      context 'for working and storing' do
        it 'returns nothing and is therefore not available' do
          real_estate = Export::Idx301::RealEstateDecorator.new(
            mock_model(RealEstate, :for_work_or_storage? => true, :pricing => mock_model(Pricing, :additional_costs => '2.50')),
            account,
            {}
          )
          real_estate.rent_extra.should be_nil
        end

      end

      it 'returns the rounded price' do
        real_estate = Export::Idx301::RealEstateDecorator.new(
          mock_model(RealEstate, :for_work_or_storage? => false, :pricing => mock_model(Pricing, :additional_costs => '2.50')),
          account,
          {}
        )
        real_estate.rent_extra.should be(3)
      end
    end

    context 'without a price' do
      it 'returns nothing and is therefore not available' do
        real_estate = Export::Idx301::RealEstateDecorator.new(
          mock_model(RealEstate, :for_work_or_storage? => false, :pricing => mock_model(Pricing, :additional_costs => '')),
          account,
          {}
        )
        real_estate.rent_extra.should be_nil
      end
    end
  end

  describe '#selling_price' do
    context 'for rent' do
      let :decorated_real_etate do
        Export::Idx301::RealEstateDecorator.new(
          mock_model(RealEstate,
            :for_rent? => true,
            :pricing => mock_model(Pricing, :for_rent_netto => 200, :additional_costs => 100)
          ),
          account,
          {}
        )
      end

      context 'when it\'s for work or storage' do
        it 'returns the netto price' do
          decorated_real_etate.model.stub(:for_work_or_storage?).and_return(true)
          decorated_real_etate.selling_price.should == 200
        end
      end

      context 'when it\'s for any other use' do
        it 'returns the price with the added rent extra' do
          decorated_real_etate.model.stub(:for_work_or_storage?).and_return(false)
          decorated_real_etate.selling_price.should == 300
        end
      end
    end
  end

  describe '#url' do
    let :decorated_real_etate do
      Export::Idx301::RealEstateDecorator.new(
        mock_model(RealEstate,
          link_url: 'http://www.feldpark-zug.ch'
        ),
        account,
        {}
      )
    end

    it 'returns the project website link' do
      expect(decorated_real_etate.url).to eq 'http://www.feldpark-zug.ch'
    end
  end

  describe 'agency adress' do
    let :decorator do
      d = Export::Idx301::RealEstateDecorator.new(mock_model(RealEstate), account, {})
      d.model.stub(:office).and_return(mock_model(Office, :company_label => 'Migros',
                                 :street => 'Am See 12',
                                 :zip => '12345',
                                 :city => 'Basel',
                                 :phone => '123',
                                 :fax => '321'))
      d
    end

    describe '#agency_name' do
      it 'returns the offices name' do
        decorator.agency_name.should == 'Migros'
      end
    end

    describe '#agency_street' do
      it 'returns the offices street' do
        decorator.agency_street.should == 'Am See 12'
      end
    end

    describe '#agency_zip' do
      it 'returns the offices zip' do
        decorator.agency_zip.should == '12345'
      end
    end

    describe '#agency_city' do
      it 'returns the offices city' do
        decorator.agency_city.should == 'Basel'
      end
    end

    describe '#agency_phone' do
      context 'when a contact phone is present' do
        it 'returns the contacts phone number' do
          decorator.model.stub_chain(:contact, :phone).and_return('987')
          decorator.agency_phone.should == '987'
        end
      end

      context 'when the contact phone is not present' do
        it 'returns the offices phone number' do
          decorator.model.stub_chain(:contact, :phone).and_return('')
          decorator.agency_phone.should == '123'
        end
      end
    end

    describe '#agency_fax' do
      context 'when a contact fax is present' do
        it 'returns the contacts fax number' do
          decorator.model.stub_chain(:contact, :fax).and_return('789')
          decorator.agency_fax.should == '789'
        end
      end

      context 'when the contacts fax is not present' do
        it 'returns the offices fax number' do
          decorator.model.stub_chain(:contact, :fax).and_return('')
          decorator.agency_fax.should == '321'
        end
      end
    end
  end
end
