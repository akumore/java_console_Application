require 'spec_helper'

describe RealEstatesHelper do
  describe '#caption_css_class_for_text' do
    context 'with a long text' do
      it 'has the long shard image' do
        caption_css_class_for_text('a'*50).should == 'flex-caption wide'
      end
    end

    context 'with a short text' do
      it 'has the default shard image' do
        caption_css_class_for_text('a'*25).should == 'flex-caption'
      end
    end
  end
end
