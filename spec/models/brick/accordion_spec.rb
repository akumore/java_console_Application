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
end
