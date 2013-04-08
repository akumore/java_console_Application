require 'spec_helper'

describe Cms::GalleryPhotosController do

  it_should_behave_like "All CMS controllers not accessible to editors", :gallery_photo

end

