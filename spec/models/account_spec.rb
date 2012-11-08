require 'spec_helper'

describe Account do
  describe 'invalid account' do
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
end
