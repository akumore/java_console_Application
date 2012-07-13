require 'spec_helper'

describe ReferenceProjectDecorator do

  let :reference_project do
    Fabricate :reference_project
  end

  let :reference_project_decorator do
    ReferenceProjectDecorator.decorate reference_project
  end

  describe '#is_wide_content' do
    it 'returns true if content is wider than 150 chars' do
      reference_project.description.stub(:length => 10)
      reference_project_decorator.is_wide_content?.should be_false
    end

    it 'returns false if content is narrower than 150 chars' do
      reference_project.description.stub(:length => 160)
      reference_project_decorator.is_wide_content?.should be_true
    end

    describe 'with no description' do

      let :reference_project do
        Fabricate :reference_project, :description => nil
      end

      it 'returns false' do
        reference_project_decorator.is_wide_content?.should be_false
      end
    end
  end

  describe '#title' do
    it 'truncates title to 40 chars' do
      project = Fabricate :reference_project, :title => '01234567801234567899012345678901234567890123456789'
      decorator = ReferenceProjectDecorator.decorate project
      decorator.title.should == '0123456780123456789901234567890123456...'
    end
  end
end
