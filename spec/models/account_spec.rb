require 'spec_helper'

describe Account do
  describe '#initialize' do
    context 'without data' do

      let :invalid_account do
        a = Account.new
        a.valid?
        a
      end

      it 'needs a provider' do
        invalid_account.should have(1).error_on(:provider)
      end

      it 'needs an agency_id' do
        invalid_account.should have(1).error_on(:agency_id)
      end

      it 'needs a sender_id' do
        invalid_account.should have(1).error_on(:sender_id)
      end

      it 'needs a username' do
        invalid_account.should have(1).error_on(:username)
      end

      it 'needs a password' do
        invalid_account.should have(1).error_on(:password)
      end

      it 'needs a host' do
        invalid_account.should have(1).error_on(:host)
      end
    end

    context 'with data' do
      let :valid_account do
        Account.new :provider => Provider::HOMEGATE,
                    :agency_id => 'some_id',
                    :sender_id => 'sender_stuff',
                    :username => 'tester',
                    :password => 'testing',
                    :host => 'ftp://stuff.testing.com'
      end
      it 'is valid' do
        valid_account.valid?.should be_true
      end
    end
  end

  describe '#offices' do
    before do
      Office.stub!(:where).and_return [
        Fabricate.build(:office, :name => 'baar'),
        Fabricate.build(:office, :name => 'camorino')
      ]
    end

    it 'returns the assigned offices' do
      account = Account.new(:offices => %w(baar camorino))
      account.offices.should == Office.where(:name => [:baar, :camorino]).to_a
    end
  end

  describe '#real_estates' do
    it 'returns all real estates for the given offices' do
      account = Account.new(:offices => %w(baar marin))
      RealEstate.should_receive(:where).with(:office_id.in => account.offices.map(&:id))
      account.real_estates
    end
  end

  describe '#video_support?' do
    it 'should be true' do
      Account.new(:video_support => true).video_support.should be_true
    end
  end

  describe '#name' do
    it 'returns a unique name' do
      account = Account.new(:provider => 'test', :offices => %w(camorino baar))
      account.name.should == 'test_camorino_baar'
    end

    it 'does not fail' do
      expect { Account.new.name }.to_not raise_error
    end
  end

  describe '.all' do
    it 'returns a list of all accounts' do
      Account.all.should be_all { |a| a.should be_a(Account) }
    end
  end
end
