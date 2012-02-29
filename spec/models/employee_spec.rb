require 'spec_helper'

describe Employee do
  describe 'initialize without any attributes' do
    before :each do
      @employee = Employee.new
    end

    it 'does not pass validations' do
      @employee.should_not be_valid
    end

    it 'requires a firstname' do
      @employee.should have(1).error_on(:firstname)
    end

    it 'requires a lastname' do
      @employee.should have(1).error_on(:lastname)
    end

    it 'requires a phone number' do
      @employee.should have(1).error_on(:phone)
    end

    it 'requires an email' do
      @employee.should have(1).error_on(:email)
    end

    it 'requires an department' do
      @employee.should have(1).error_on(:department)
    end

    it 'has 5 errors' do
      @employee.valid?
      @employee.errors.should have(5).items
    end
  end

  describe '#fullname' do
    it 'builds it from the firstname and lastname' do
      employee = Fabricate.build(:employee)
      employee.fullname.should == "#{employee.firstname} #{employee.lastname}"
    end
  end

  describe '#fullname_reversed' do
    it 'builds it from lastname and firstname' do
      employee = Fabricate.build(:employee)
      employee.fullname_reversed.should == "#{employee.lastname}, #{employee.firstname}"
    end
  end
end
