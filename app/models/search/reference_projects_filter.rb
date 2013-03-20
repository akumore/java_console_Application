module Search
  class ReferenceProjectsFilter

    include ReferenceProjectSection::Accessors

    include ActiveModel::Conversion
    extend ActiveModel::Translation

    attr_accessor :section

    def initialize(params={})
      params.each do |key, value|
        send("#{key}=", value.presence)
      end

      @section ||= ReferenceProjectSection::RESIDENTIAL_BUILDING
    end

    def persisted?
      false
    end
  end
end
