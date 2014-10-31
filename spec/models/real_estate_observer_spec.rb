require 'spec_helper'

describe RealEstateObserver do

  # mongoid observers are singletons
  subject { RealEstateObserver.instance }

  let :real_estate do
    RealEstate.new :title => 'Test'
  end

  describe '#after_create' do
    it 'clears the cache' do
      RealEstateObserver.should_receive(:expire_cache_for)
      subject.after_create(real_estate)
    end
  end

  describe '#after_update' do
    it 'clears the cache' do
      RealEstateObserver.should_receive(:expire_cache_for)
      subject.after_update(real_estate)
    end
  end

  describe '#after_destroy' do
    it 'clears the cache' do
      RealEstateObserver.should_receive(:expire_cache_for)
      subject.after_destroy(real_estate)
    end
  end

  describe '#expire_cache_for' do
    it 'should not fail' do
      expect { RealEstateObserver.expire_cache_for real_estate }.to_not raise_error
    end

    it 'clears the html and pdf cache for all locales' do

      I18n.available_locales.each do |locale|
        %w(html pdf).each do |format|
          RealEstateObserver.context.should_receive(:expire_page).with(real_estate.handout.cache_key(format, locale))
        end
      end

      RealEstateObserver.expire_cache_for(real_estate)
    end
  end
end
