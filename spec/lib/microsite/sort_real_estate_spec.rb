# encoding: utf-8

require 'active_support/all'
require 'microsite/sort_real_estate'

module Microsite
  describe SortRealEstates do

    let :private_real_estate do
      stub(
        :private_utilization? => true,
        :commercial_utilization? => false,
        :category_label => nil,
      )
    end

    let :commercial_real_estate do
      stub(:commercial_utilization? => true)
    end



  end
end
