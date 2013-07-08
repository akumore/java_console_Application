require 'spec_helper'

describe Job do
  describe 'initialize without any attributes' do
    before :each do
      @job = Job.new
    end

    it 'does not pass validations' do
      @job.should_not be_valid
    end

    it 'has 2 errors' do
      @job.valid?
      @job.errors.should have(2).items
    end
  end

  describe 'initialize with valid attributes' do
    before :each do
      @job = Fabricate.build(:job)
    end

    it 'passes validations' do
      @job.should be_valid
    end

    it 'has an attached job_profile' do
      @job.job_profile_file.url.should be_present
    end
  end

  describe 'initialize with invalid job profile file' do
    before :each do
      @job = Fabricate.build(:job,
        :job_profile_file => File.open("#{Rails.root}/spec/support/test_files/video.mp4")
      )
    end

    it 'fails validations' do
      @job.save
      @job.should_not be_valid
    end
  end

  describe 'sort by position' do
    before :each do
      @job = Fabricate.build(:job)
    end

    it 'has set position to 1 when job is created' do
      @job.save
      @job.position.should == 1
    end

    it 'increments position on creating two jobs' do
      job_one = Fabricate(:job)
      job_one.save
      job_two = Fabricate(:job)
      job_two.save

      job_one.position.should == 1
      job_two.position.should == 2
    end
  end

end
