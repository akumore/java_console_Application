# encoding: utf-8

require "spec_helper"

describe "Pages" do

  describe 'Jobs' do
    before :each do
      @page = Fabricate(:page, :name => 'jobs')
      @page.bricks << Fabricate.build(:placeholder_brick, :placeholder => 'jobs_openings')

      Fabricate(:job) # create unpublished job
      3.times { Fabricate(:published_job) }
      visit I18n.t('jobs_url')
    end

    it 'has an accordion with 3 jobs' do
      page.should have_css('.jobs .accordion-item', :count => 3)
    end
  end

end
