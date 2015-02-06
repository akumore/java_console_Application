# encoding: utf-8
require 'spec_helper'

describe 'Cms::RealEstate utilization - category - building-type dependency' do

  login_cms_user

  before :each do
    Fabricate(:category,
              :id => 1,
              :name => 'flat',
              :label => 'Appartment',
              :utilization => Utilization::LIVING,
              :utilization_sort_order => 3
    )

    Fabricate(:category,
              :id => 2,
              :name => 'roof_flat',
              :label => 'Dachwohnung',
              :utilization => Utilization::LIVING,
              :utilization_sort_order => 2
    )

    Fabricate(:category,
              :id => 3,
              :name => 'single_room',
              :label => 'Einzelzimmer',
              :utilization => Utilization::LIVING,
              :utilization_sort_order => 1
    )

    @working_category = Fabricate(:category,
              :id => 4,
              :name => 'office',
              :label => 'Büro',
              :utilization => Utilization::WORKING,
              :utilization_sort_order => 1
    )

    visit new_cms_real_estate_path
  end

  context 'creating a new real estate' do

    it 'has the living utilization selected' do
      find(:css, '#real_estate_utilization option[selected]').value.should == Utilization::LIVING
    end

    it 'has only the living categories in the category drop-down available' do
      page.should have_css('#real_estate_category_id option', :count => 3)

      within('select#real_estate_category_id') do
        find('option[value="1"]').text.should == 'Appartment'
        find('option[value="2"]').text.should == 'Dachwohnung'
        find('option[value="3"]').text.should == 'Einzelzimmer'
      end
    end

    it 'has the right sort order in the category drop-down' do
      string = "Einzelzimmer\nDachwohnung\nAppartment"
      page.find('select#real_estate_category_id').text.should eq(string)
    end

    it 'has the building-type radio buttons hidden' do
      page.should have_css('.building-type-container.hidden')
    end

    describe 'switching utilization', :js => true do
      it 'shows immediately the working categories only' do
        select('Arbeiten', :from => 'Gebäudenutzung')

        page.should have_css('#real_estate_category_id option', :count => 1)
        within('select#real_estate_category_id') do
          find('option[value="4"]').text.should == 'Büro'
        end
      end
    end

    describe 'switching category to Reiheneinfamilienhaus', :js => true do
      before :each do
        Fabricate(:category,
              :name => 'row_house',
              :label => 'Reiheneinfamilienhaus',
              :utilization => Utilization::LIVING
        )
        visit new_cms_real_estate_path
        select 'Reiheneinfamilienhaus', :from => 'Objekt-Art'
      end

      it 'shows the building-type immediately' do
        page.should have_css('.building-type-container:not(.hidden)')
      end

      describe 'switching utilization' do
        it 'hides the building-type immediately' do
          select('Arbeiten', :from => 'Gebäudenutzung')
          page.should have_css('.building-type-container.hidden')
        end
      end
    end

  end

  context 'editing a real estate' do

    before :each do
      @real_estate = Fabricate(:commercial_building,
                               :category => @working_category,
                               :state => RealEstate::STATE_EDITING )
      visit edit_cms_real_estate_path(@real_estate)
    end

    it 'has only the working categories in the category drop-down available' do
      page.should have_css('#real_estate_category_id option', :count => 1)
      within('select#real_estate_category_id') do
        find('option[value="4"]').text.should == 'Büro'
      end
    end

  end

end
