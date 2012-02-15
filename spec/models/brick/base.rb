require 'spec_helper'

describe Brick::Base do
  describe 'siblings navigation' do
    before :each do
      @page = Fabricate(:page, :name => 'siblings_test_page')
      @page.bricks << Fabricate.build(:text_brick)
      @page.bricks << Fabricate.build(:text_brick)
      @page.bricks << Fabricate.build(:text_brick)
    end

    describe '#next' do
      it 'knows the next brick' do
        @page.bricks.first.next.should == @page.bricks.second
      end

      context 'the last brick' do
        it 'has no next brick' do
          @page.bricks.last.next.should be_nil
        end
      end
    end

    describe '#prev' do
      it 'knows the previous brick' do
        @page.bricks.last.prev.should == @page.bricks.second
      end

      context 'the first brick' do
        it 'has no prev brick' do
          @page.bricks.first.prev.should be_nil
        end
      end
    end
  end
end
