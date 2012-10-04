require 'spec_helper'

describe Export::Idx301::Cleanup do

  describe '#removable_exports' do
    it 'returns a list of export folders older then 5 days' do
      cleaner = Export::Idx301::Cleanup.new('tmp/export')
      cleaner.should_receive(:entries).and_return(['.', '..', '2012_02_01', '2012_04_12', '2048_01_09'])
      cleaner.removable_exports.should == ['2012_02_01', '2012_04_12']
    end
  end

  describe '#run' do
    it 'removes all removable export directories from disc' do
      cleaner = Export::Idx301::Cleanup.new('tmp/export')
      cleaner.should_receive(:removable_exports).and_return(['2012_02_01', '2012_04_12'])
      FileUtils.should_receive(:rm_rf).with('tmp/export/2012_02_01')
      FileUtils.should_receive(:rm_rf).with('tmp/export/2012_04_12')
      cleaner.run
    end
  end
end
