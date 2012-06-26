require 'spec_helper'

describe Page do
  describe 'initialize without any attributes' do
    before :each do
      @page = Page.new
    end

    it 'does not pass validations' do
      @page.should_not be_valid
    end

    it 'has 4 errors' do
      @page.valid?
      @page.errors.should have(4).items
    end
  end

  describe 'initialize with valid attributes' do
    before :each do
      @page = Fabricate.build(:page)
    end

    it 'passes validations' do
      @page.should be_valid
    end
  end

  describe 'saving without a unique name' do
    it 'raises an error' do
      Fabricate(:page, :name => 'uniquename')
      expect { Fabricate(:page, :name => 'uniquename') }.to raise_error
    end
  end

  describe '.jobs_page' do
    it 'finds the jobs page' do
      jobs_page = Fabricate(:page, :name => 'jobs', :locale => I18n.locale)
      Page.jobs_page.should == jobs_page
    end
  end

  describe '.company_page' do
    it 'finds the company page' do
      company_page = Fabricate(:page, :name => 'company', :locale => I18n.locale)
      Page.company_page.should == company_page
    end
  end

  describe '.subnavigation' do
    it 'returns only secondary titles' do
      page = Page.create(:name => 'dummy', :title => 'Dummy', :locale => I18n.locale) do |page|
        page.bricks << Brick::Title.new(:title => 'Test')
        page.bricks << Brick::Text.new(:text => 'Hi there')
        page.bricks << Brick::Title.new(:title => 'Test2')
      end

      page.subnavigation.count.should be(1)
    end
  end
end
