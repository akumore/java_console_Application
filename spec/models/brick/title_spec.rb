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
end
