module Concerns
  module SpamProtection
    extend ActiveSupport::Concern

    included do
      # field that must be empty to protect from spam
      field :unnecessary_field, :type => String
      validates :unnecessary_field, inclusion: {in: ['', nil]}
    end

  end
end
