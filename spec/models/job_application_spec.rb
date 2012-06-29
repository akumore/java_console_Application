require 'spec_helper'

describe JobApplication do
  describe 'initialize without any attributes' do
    before :each do
      @job_application = JobApplication.new
    end

    it 'does not pass validations' do
      @job_application.should_not be_valid
    end

    it 'has 8 errors' do
      @job_application.valid?
      @job_application.errors.should have(9).items
    end
  end

  describe 'initialize with valid attributes' do
    before :each do
      @job_application = Fabricate.build(:job_application)
    end

    it 'passes validations' do
      @job_application.should be_valid
    end
  end
end
