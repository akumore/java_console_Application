require 'spec_helper'

describe Page do
  describe 'initialize without any attributes' do
    before :each do
      @page = Page.new
    end

    it 'does not pass validations' do
      expect(@page).to_not be_valid
    end

    it 'has 4 errors' do
      @page.valid?
      expect(@page.errors).to have(4).items
    end
  end

  describe 'initialize with valid attributes' do
    before :each do
      @page = Fabricate.build(:page)
    end

    it 'passes validations' do
      expect(@page).to be_valid
    end
  end

  describe 'saving without a unique name' do
    it 'raises an error' do
      Fabricate(:page, name: 'uniquename')
      expect { Fabricate(:page, name: 'uniquename') }.to raise_error
    end
  end

  describe '.jobs_page' do
    it 'finds the jobs page' do
      jobs_page = Fabricate(:page, name: 'jobs', locale: I18n.locale)
      expect(Page.jobs_page).to eq(jobs_page)
    end
  end

  describe '.company_page' do
    it 'finds the company page' do
      company_page = Fabricate(:page, name: 'company', locale: I18n.locale)
      expect(Page.company_page).to eq(company_page)
    end
  end

  describe '.subnavigation' do
    it 'returns children of page' do
      page = Page.create(name: 'dummy', title: 'Dummy', locale: I18n.locale)
      Page.create(title: 'Sub Page 1', name: 'sub_page_1', locale: I18n.locale, parent_id: page.id)
      Page.create(title: 'Sub Page 2', name: 'sub_page_2', locale: I18n.locale, parent_id: page.id)
      Page.create(title: 'Sub Page 3', name: 'sub_page_3', locale: I18n.locale, parent_id: page.id)

      expect(page.subnavigation.count).to eq(3)
    end
  end
end
