require 'spec_helper'

describe Brick::Accordion do
  describe 'initialize without any attributes' do
    before :each do
      @brick = Brick::Accordion.new
    end

    it 'does not pass validations' do
      @brick.should_not be_valid
    end

    it 'has 2 error' do
      @brick.valid?
      @brick.errors.should have(2).items
    end
  end

  describe 'initialize with valid attributes' do
    before :each do
      @brick = Fabricate.build(:accordion_brick)
    end

    it 'passes validations' do
      @brick.should be_valid
    end
  end

  describe '#group_id' do
    before :each do
      @page = Fabricate(:page, :name => 'accordion_test_page')
      @page.bricks << Fabricate.build(:accordion_brick)
      @page.bricks << Fabricate.build(:accordion_brick)
      @page.bricks << Fabricate.build(:text_brick)
      @page.bricks << Fabricate.build(:accordion_brick)
      @page.bricks << Fabricate.build(:accordion_brick)
    end

    it 'returns the same group_id for adjacent accordion bricks' do
      @page.bricks.second.group_id.should == @page.bricks.first.group_id
    end

    it 'returns a new group_id for non-adjacent accordion bricks' do
      @page.bricks.last.group_id.should_not == @page.bricks.first.group_id
    end
  end
end
