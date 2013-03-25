# encoding: utf-8
require "spec_helper"

describe "Page Header" do
  monkey_patch_default_url_options

  describe 'slider', :js => true do
    
    context 'on the homepage' do
      before :each do
        visit root_path
      end

      it 'has a slider' do
        within('.vision-slider') do
          page.should have_css('.flexslider', :count => 1)
        end
      end

      it 'is open by default' do
        page.should have_css('.vision-slider-open .vision-slider', :count => 1)
      end

      it 'can be toggled' do
        within('.vision-slider') do
          page.find('.toggle').click
        end
        
        page.should_not have_css('.vision-slider-open .vision-slider', :count => 1)

        within('.vision-slider') do
          page.find('.toggle').click
        end

        page.should have_css('.vision-slider-open .vision-slider', :count => 1)
      end

      context 'persisting the toggled state between pages' do
        it 'is stays closed' do
          # check that it's open by default
          page.should have_css('.vision-slider-open .vision-slider', :count => 1)

          within('.vision-slider') do
            page.find('.toggle').click
          end

          # now it should be closed …
          page.should_not have_css('.vision-slider-open .vision-slider', :count => 1)

          visit root_path

          # … and it should still be after revisiting
          page.should_not have_css('.vision-slider-open .vision-slider', :count => 1)

        end
      end
    end

    context 'on any other page than the homepage' do
      before :each do
        visit real_estates_path
      end

      it 'has a slider' do
        within('.vision-slider') do
          page.should have_css('.flexslider', :count => 1)
        end
      end

      it 'is always closed upon visiting' do
        page.should_not have_css('.vision-slider-open .vision-slider', :count => 1)
      end

      it 'does not persist the open/closed state' do
        # check that it's closed by default
        page.should_not have_css('.vision-slider-open .vision-slider', :count => 1)

        within('.vision-slider') do
          page.find('.toggle').click
        end

        # now it should be open …
        page.should have_css('.vision-slider-open .vision-slider', :count => 1)

        visit real_estates_path

        # … and it should be closed upon revisiting
        page.should_not have_css('.vision-slider-open .vision-slider', :count => 1)
      end
    end

  end
end