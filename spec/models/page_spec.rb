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
end
