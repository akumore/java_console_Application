class AddMissingEditorToRealEstateInReview < Mongoid::Migration
  def self.up
    RealEstate.where(:state => RealEstate::STATE_IN_REVIEW, :editor_id => nil).each do |real_estate|
      editor = Cms::User.where(:email => 'admin@screenconcept.ch').first
      if editor.present?
        real_estate.editor = editor
        real_estate.save!
      else
        real_estate.reject_it!
      end
    end
  end

  def self.down
  end
end
