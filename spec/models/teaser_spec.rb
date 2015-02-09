require 'spec_helper'

describe Teaser do
  describe 'current locale' do
    before :each do
      @teaser1 = Fabricate(:teaser, title: 'de teaser 1')
      @teaser2 = Fabricate(:teaser, title: 'de teaser 2')
    end

    it 'returns for fr locale' do
      I18n.with_locale(:fr) do
        @teaser3 = Fabricate(:teaser, title: 'fr teaser 1', locale: 'fr')
        @teaser4 = Fabricate(:teaser, title: 'fr teaser 1', locale: 'fr')
        Teaser.with_current_locale.to_a.should eq([@teaser3, @teaser4])
      end
    end

    it 'returns for de locale' do
      Teaser.with_current_locale.to_a.should eq([@teaser1, @teaser2])
    end
  end
end
