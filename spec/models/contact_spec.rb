require 'spec_helper'

describe Contact do
  describe 'initialize without any attributes' do
    before :each do
      @contact = Contact.new
    end

    it 'does not pass validations' do
      @contact.should_not be_valid
    end

    it 'has 6 errors' do
      @contact.valid?
      @contact.errors.should have(6).items
    end
  end

  describe 'initialize with valid attributes' do
    before :each do
      @contact = Fabricate.build(:contact)
    end

    it 'passes validations' do
      @contact.should be_valid
    end
  end
end
