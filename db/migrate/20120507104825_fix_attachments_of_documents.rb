class FixAttachmentsOfDocuments < Mongoid::Migration
  def self.up
    real_estates = RealEstate.all.select {|r| r.documents.any?}
    real_estates.each do |real_estate|
      new_documents = []
      real_estate.documents.each do |document|
        new_documents << copy_asset(document)
      end

      new_documents.each do |doc|
        puts "Invalid document found for real estate #{real_estate.id}" unless doc.valid?
        real_estate.documents << doc
      end
      puts "Copied #{new_documents.size} documents of real estate #{real_estate.id}"
    end

    #cleanup
    real_estates = RealEstate.all.select {|r| r.documents.any?}
    real_estates.each do |real_estate|
      real_estate.documents.each do |doc|
        if doc.created_at < (Time.now - 5.minutes)
          puts "Destroying document #{doc.id}, title: #{doc.title}, created_at: #{doc.created_at} of real estate #{real_estate.id}"
          doc.destroy
        end
      end
    end

  end

  def self.down
    raise Mongoid::IrreversibleMigration.new("Redoing this migration will remove all assets created_at < Time.now - 5.minutes")
  end


  private
  def self.copy_asset(asset)
    MediaAssets::Document.new extract_asset_params(asset)
  end

  def self.extract_asset_params(asset)
    [:title, :file, :is_primary, :position].inject({}) do |h, attr|
      h[attr] = asset.send(attr) if asset.respond_to?(attr)
      h
    end
  end

end