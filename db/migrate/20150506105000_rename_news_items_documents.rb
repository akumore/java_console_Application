class RenameNewsItemsDocuments < Mongoid::Migration
  def self.up
    NewsItem.collection.update({}, { '$rename' => { "documents" => "documents_de"} }, :multi => true)
  end

  def self.down
    NewsItem.collection.update({}, { '$rename' => { "documents_de" => "documents"} }, :multi => true)
  end
end
