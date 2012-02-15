require 'spec_helper'

describe Brick::Placeholder do
  describe 'initialize without any attributes' do
    before :each do
      @brick = Brick::Placeholder.new
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
      @brick = Fabricate.build(:placeholder_brick)
    end

    it 'passes validations' do
      @brick.should be_valid
    end
  end
end
