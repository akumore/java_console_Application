class UpdateOldNewsItemRecords < Mongoid::Migration
  def self.up
    NewsItem.update_all(published:true)
  end

  def self.down
    NewsItem.update_all(published: nil)
  end
end
