require 'spec_helper'

describe Reference do
  let(:reference_attributes) { Fabricate.attributes_for(:reference) }
  let(:real_estate) { 
    Fabricate.build(:real_estate, 
                    channels: [RealEstate::EXTERNAL_REAL_ESTATE_PORTAL_CHANNEL],
                    reference: Fabricate.build(:reference, reference_attributes),
                    category: Fabricate(:category)) 
  }
  let(:published_real_estate) { 
    Fabricate.build(:published_real_estate, 
                    channels: [RealEstate::EXTERNAL_REAL_ESTATE_PORTAL_CHANNEL],
                    reference: Fabricate.build(:reference, reference_attributes), 
                    category: Fabricate(:category)) 
  }

  context 'published real estate' do
    before do
      expect(published_real_estate.save).to be_true
    end

    it 'is not possible to save a reference with the same keys' do
      expect(RealEstate.matching_real_estates(reference_attributes)).to be_true

      real_estate_from_santa_claus = Fabricate.build(:published_real_estate, 
                                                     channels: [RealEstate::EXTERNAL_REAL_ESTATE_PORTAL_CHANNEL],
                                                     reference: Fabricate.build(:reference, reference_attributes),
                                                     category: Fabricate(:category))
      expect(real_estate_from_santa_claus).not_to be_valid
      expect(real_estate_from_santa_claus.save).to be_false
    end
  end

  context 'unpublished real estate' do
    before do
      expect(real_estate.save).to be_true
    end

    context 'channel "external_real_estate_portal" is not set' do
      it 'is possible to save real estate' do
        valid_real_estate = Fabricate.build(:real_estate, 
                                      channels: [RealEstate::WEBSITE_CHANNEL],
                                      category: Fabricate(:category))
        expect(valid_real_estate.save).to be_true
      end
    end

    context 'channel "external_real_estate_portal" is set' do
      it 'is not possible to save the real estate without a reference field set' do
        invalid_real_estate = Fabricate.build(:real_estate, 
                                              channels: [RealEstate::EXTERNAL_REAL_ESTATE_PORTAL_CHANNEL],
                                              reference: Fabricate.build(:reference, {
                                                property_key: nil,
                                                building_key: nil,
                                                unit_key: nil
                                              }),
                                              category: Fabricate(:category))
        expect(invalid_real_estate.valid?).to be_false
        expect(invalid_real_estate.save).to be_false
      end

      let(:valid_real_estate) do
        Fabricate.build(:real_estate, 
                        channels: [RealEstate::EXTERNAL_REAL_ESTATE_PORTAL_CHANNEL],
                        reference: Fabricate.build(:reference, {
                          property_key: '123',
                          building_key: 'fff',
                          unit_key: 'xxx'
                        }),
                        category: Fabricate(:category))
      end
      it 'is possible to save the real estate by set at least one reference field' do
        expect(valid_real_estate.valid?).to be_true
        expect(valid_real_estate.save).to be_true
      end

      it 'is possible to clone with reference' do
        valid_real_estate.save!
        id = valid_real_estate.id
        expect(valid_real_estate.reference.property_key).not_to be_nil
        expect(valid_real_estate.reference.building_key).not_to be_nil
        expect(valid_real_estate.reference.unit_key).not_to be_nil
        clone = RealEstate.copy!(valid_real_estate)
        expect(clone.channels).to eq([])
        expect(clone.reference.property_key).to be_nil
        expect(clone.reference.building_key).to be_nil
        expect(clone.reference.unit_key).to be_nil
        v = RealEstate.find(id)
        # ensure that original real estate did not change
        expect(v.channels).to eq([RealEstate::EXTERNAL_REAL_ESTATE_PORTAL_CHANNEL])
        expect(v.reference.property_key).not_to be_nil
        expect(v.reference.building_key).not_to be_nil
        expect(v.reference.unit_key).not_to be_nil
      end

      it 'is not possible to save a reference with the same keys' do
        real_estate_from_santa_claus = Fabricate.build(:real_estate, 
                                                     channels: [RealEstate::EXTERNAL_REAL_ESTATE_PORTAL_CHANNEL],
                                                     reference: Fabricate.build(:reference, reference_attributes),
                                                     category: Fabricate(:category))
        expect(real_estate_from_santa_claus).not_to be_valid
        expect(real_estate_from_santa_claus.save).to be_false
      end
    end

    context 'channel "external_real_estate_portal" is unset' do
      it 'sets reference of real estate to nil' do
        real_estate.update_attributes(channels: [RealEstate::WEBSITE_CHANNEL])
        expect(real_estate.reference.property_key).to be_nil
        expect(real_estate.reference.building_key).to be_nil
        expect(real_estate.reference.unit_key).to be_nil
      end
    end
  end
end
