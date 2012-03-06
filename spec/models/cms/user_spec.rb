require 'spec_helper'

describe Cms::User do
  describe 'initialize without any attributes' do
    before :each do
      @user = Cms::User.new
    end

    it 'does not pass validations' do
      @user.should_not be_valid
    end

    it 'requires an email' do
      @user.should have(1).error_on(:email)
    end

    it 'requires a role' do
      @user.should have(2).error_on(:role)
    end

    it 'requires a password' do
      @user.should have(1).error_on(:password)
    end

    it 'has 4 errors' do
      @user.valid?
      @user.errors.should have(4).items
    end
  end  
end
