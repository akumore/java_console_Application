require 'spec_helper'

describe Brick::Title do
  describe 'initialize without any attributes' do
    before :each do
      @brick = Brick::Title.new
    end

    it 'does not pass validations' do
      @brick.should_not be_valid
    end

    it 'has 1 error' do
      @brick.valid?
      @brick.errors.should have(1).items
    end
  end

  describe 'initialize with valid attributes' do
    before :each do
      @brick = Fabricate.build(:title_brick)
    end

    it 'passes validations' do
      @brick.should be_valid
    end
  end

  describe '#is_primary?' do
    before :each do
      @page = Fabricate(:page, :name => 'title_test_page')
      @page.bricks << Fabricate.build(:text_brick)
      @page.bricks << Fabricate.build(:title_brick)
      @page.bricks << Fabricate.build(:text_brick)
      @page.bricks << Fabricate.build(:title_brick)
    end

    it 'returns true for the first title brick in the collection' do
      @page.bricks[1].is_primary?.should be_true
    end

    it 'returns false for any other title brick in the collection' do
      @page.bricks.last.is_primary?.should be_false
    end
  end
end
