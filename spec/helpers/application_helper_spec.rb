# encoding: utf-8

require 'spec_helper'

describe ApplicationHelper do
  context '#css_class_for_same_teaser_height' do
    before :each do
      @teaser = Fabricate(:teaser)
      @brick1 = Fabricate.build(:teaser_brick, teaser_2: nil)
      @brick2 = Fabricate.build(:teaser_brick)
    end

    it 'does not return class when brick has two teasers in same row' do
      css_class_for_same_teaser_height(@brick1.teaser_1, @brick1.teaser_2).should == nil
    end

    it 'returns class when brick has two teasers in same row' do
      css_class_for_same_teaser_height(@brick2.teaser_1, @brick2.teaser_2).should == 'teasers-have-same-height'
    end
  end
end
