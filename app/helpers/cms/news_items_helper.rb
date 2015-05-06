module Cms
  module NewsItemsHelper

    def localized_documents
      "documents_#{content_locale}"
    end
  end
end
