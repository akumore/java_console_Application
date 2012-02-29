# encoding: utf-8
require 'spec_helper'

describe "Cms::Employees" do
  login_cms_user

  describe '#index' do
    before do
      3.times { Fabricate(:employee) }
      @employee = Employee.first
      visit cms_employees_path
    end

    it "shows the list of employees" do
      page.should have_selector('table tr', :count => Employee.count+1)
    end

    it "takes me to the edit page of a employee" do
      within("#employee_#{@employee.id}") do
        page.click_link 'Editieren'
      end
      current_path.should == edit_cms_employee_path(@employee)
    end

    it "takes me to the page for creating a new employee" do
      page.click_link 'Neuen Mitarbeiter erfassen'
      current_path.should == new_cms_employee_path
    end
  end

  describe '#new' do
    before :each do
      visit new_cms_employee_path
    end

    it 'opens the create form' do
      current_path.should == new_cms_employee_path
    end

    context 'a valid Employee' do
      before :each do
        within(".new_employee") do
          fill_in 'Vorname', :with => 'Max'
          fill_in 'Nachname', :with => 'Bill'
          fill_in 'Telefon', :with => '123 23 33'
          fill_in 'Mobiltelefon', :with => '079 123 23 22'
          fill_in 'Fax', :with => '123 23 22'
          fill_in 'E-Mail Adresse', :with => 'max.bill@alfred-mueller.ch'
          fill_in 'Funktion', :with => 'Geschäftsleiter'
          select 'Vermarktung', :from => 'Abteilung'
          attach_file 'Bild', "#{Rails.root}/spec/support/test_files/image.jpg"
        end
      end

      it 'save a new Employee' do
        lambda do
          click_on 'Mitarbeiter erstellen'
        end.should change(Employee, :count).from(0).to(1)
      end

      context '#create' do
        before :each do
          click_on 'Mitarbeiter erstellen'
          @employee = Employee.last
        end

        it 'has saved the provided attributes' do
          @employee.fullname.should == 'Max Bill'
          @employee.email.should == 'max.bill@alfred-mueller.ch'
          @employee.phone.should == '123 23 33'
          @employee.mobile.should == '079 123 23 22'
          @employee.fax.should == '123 23 22'
          @employee.job_function.should == 'Geschäftsleiter'
          @employee.department.should == 'marketing'
          @employee.image.should be_present
        end
      end
    end
  end

  describe '#edit' do
    before :each do
      @employee = Fabricate(:employee)
      visit edit_cms_employee_path(@employee)
    end

    it 'opens the edit form' do
      current_path.should === edit_cms_employee_path(@employee)
    end

    context '#update' do
      before :each do
        within(".edit_employee") do
          fill_in 'Vorname', :with => 'Hanna'
          fill_in 'Nachname', :with => 'Muster'
          fill_in 'Telefon', :with => '123 23 44'
          fill_in 'Mobiltelefon', :with => '079 123 23 77'
          fill_in 'Fax', :with => '123 23 88'
          fill_in 'E-Mail Adresse', :with => 'hanna.muster@alfred-mueller.ch'
          fill_in 'Funktion', :with => 'Geschäftsleiterin'
          select 'Bewirtschaftung', :from => 'Abteilung'
        end

        click_on 'Mitarbeiter speichern'
      end

      it 'has updated the edited attributes' do
        @employee.reload
        @employee.fullname.should == 'Hanna Muster'
        @employee.email.should == 'hanna.muster@alfred-mueller.ch'
        @employee.phone.should == '123 23 44'
        @employee.mobile.should == '079 123 23 77'
        @employee.fax.should == '123 23 88'
        @employee.job_function.should == 'Geschäftsleiterin'
        @employee.department.should == 'real_estate_management'
      end
    end
  end

  describe '#destroy' do
    before :each do
      @employee = Fabricate(:employee)
      visit cms_employees_path
    end

    it 'deletes the employee' do
      lambda {
        within("#employee_#{@employee.id}") do
          click_link 'Löschen'
        end
      }.should change(Employee, :count).by(-1)
    end
  end

end
