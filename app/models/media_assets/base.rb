module MediaAssets
  class Base
    include Mongoid::Document
    include Mongoid::Timestamps

    default_scope asc(:position)
    embedded_in :real_estate

    field :title, :type => String
    field :file, :type => String
    field :position, :type => Integer

    validates :title, :presence => true
    validates_presence_of :file, :if => :new_record?
    validates_length_of :title, :maximum => 50

    before_create :setup_position


    private
    def setup_position
      raise "Abstract method setup_position called."
    end

  end
end
