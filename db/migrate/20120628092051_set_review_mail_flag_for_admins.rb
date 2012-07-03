class SetReviewMailFlagForAdmins < Mongoid::Migration
  def self.up
    Cms::User.admins.each do |admin|
      admin.update_attributes :wants_review_emails => true
    end
  end

  def self.down
    Cms::User.admins.each do |admin|
      admin.update_attributes :wants_review_emails => false
    end
  end
end
