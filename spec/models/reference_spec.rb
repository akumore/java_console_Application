require 'spec_helper'

describe Reference do
  context 'with saved reference in database' do
    let(:reference_attributes) { Fabricate.attributes_for(:reference) }
    let(:published_real_estate) { Fabricate.build(:published_real_estate, :address => Fabricate.build(:address, :reference => Fabricate.build(:reference, reference_attributes)), :category => Fabricate(:category)) }
    let(:real_estate_from_santa_claus) { Fabricate.build(:published_real_estate, :category => Fabricate(:category)) }

    before do
      expect(published_real_estate.save).to be_true
    end

    it "shouldn't be possible to save the reference with the same keys" do
      expect(Reference.exists_by_attributes?(reference_attributes)).to be_true
      real_estate_from_santa_claus = Fabricate.build(:published_real_estate, :category => Fabricate(:category))
      expect(real_estate_from_santa_claus.save).to be_true
      real_estate_from_santa_claus.address = Fabricate.build(:address, :city => 'Steinhausen', :reference => Fabricate.build(:reference, reference_attributes))
      expect(real_estate_from_santa_claus).not_to be_new_record
      expect(real_estate_from_santa_claus.address.reference).not_to be_valid
      expect(real_estate_from_santa_claus.address).not_to be_valid
      expect(real_estate_from_santa_claus).not_to be_valid
      expect(real_estate_from_santa_claus.save).to be_false
    end
  end
end
