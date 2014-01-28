require 'spec_helper'

describe 'ApplicationDecorator' do

  before { ApplicationController.new.set_current_view_context }
  let(:model) { double('Information') }
  subject { ApplicationDecorator.new(model) }

  describe '#field_list_in_real_estate_language' do

    before(:each) do
      model.stub(:real_estate) { RealEstate.new(language: 'xx') }
    end

    it 'sets the real estate language before translate' do
      subject.should_receive(:myfield) {
        I18n.locale.should == :xx
        ['aa', 'bb']
      }
      subject.field_list_in_real_estate_language(:myfield).should == ["\t<li>aa</li>", "\t<li>bb</li>"]
      I18n.locale.should == :de
    end

  end

  describe '#update_list_in' do
    pending
  end

end
