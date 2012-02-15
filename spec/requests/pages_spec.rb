# encoding: utf-8

require "spec_helper"

describe "Pages" do

  describe 'Jobs' do
    before :each do
      Fabricate(:page, :name => 'jobs')
    end

    it 'renders the jobs page' do
      visit I18n.t('jobs_url')
      save_and_open_page
      page.should have_css('a.selected:contains(Jobs)')
    end
  end

end
