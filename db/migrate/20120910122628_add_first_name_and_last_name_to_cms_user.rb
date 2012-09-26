class AddFirstNameAndLastNameToCmsUser < Mongoid::Migration
  def self.up
    Cms::User.all.each do |user|
      user.first_name = user.email.split('@').first.split('.').first.capitalize

      if user.email.split('.').length == 3
        user.last_name = user.email.split('@').first.split('.').last.capitalize
      else
        user.last_name = 'Unbekannt'
      end

      user.save
    end
  end

  def self.down
  end
end
