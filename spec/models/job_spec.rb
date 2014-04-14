require 'spec_helper'

describe Job do
  describe 'initialize without any attributes' do
    before :each do
      @job = Job.new
    end

    it 'does not pass validations' do
      expect(@job).to_not be_valid
    end

    it 'has 1 error' do
      @job.valid?
      expect(@job.errors).to have(1).items
    end
  end

  describe 'initialize with valid attributes' do
    before :each do
      @job = Fabricate.build(:job)
    end

    it 'passes validations' do
      expect(@job).to be_valid
    end

    it 'has an attached job_profile' do
      expect(@job.job_profile_file.url).to be_present
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
      expect(@job).to_not be_valid
    end
  end

  describe 'sort by position' do
    before :each do
      @job = Fabricate.build(:job)
    end

    it 'has set position to 1 when job is created' do
      @job.save
      expect(@job.position).to eq(1)
    end

    it 'increments position on creating two jobs' do
      job_one = Fabricate(:job)
      job_one.save
      job_two = Fabricate(:job)
      job_two.save

      expect(job_one.position).to eq(1)
      expect(job_two.position).to eq(2)
    end
  end

end
