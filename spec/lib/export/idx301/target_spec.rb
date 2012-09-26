require 'spec_helper'

describe Export::Idx301::Target do
  let :target do
    Export::Idx301::Target.new 'portal_name', 'abcd', 'portal_exporter', {}
  end

  describe 'attributes' do
    it 'has a name' do
      target.name.should == 'portal_name'
    end

    it 'has an agency_id' do
      target.agency_id.should == 'abcd'
    end

    it 'has a sender_id' do
      target.sender_id.should == 'portal_exporter'
    end

    it 'has a config' do
      target.config.should == {}
    end
  end
end
