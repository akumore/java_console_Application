# encoding: utf-8

module Microsite
  class SortRealEstates

    def self.sort a, b
      aGroupSortKey = a.group[:sort_key]
      bGroupSortKey = b.group[:sort_key]
      if aGroupSortKey != bGroupSortKey then
        return aGroupSortKey < bGroupSortKey ? -1 : 1
      else
        aHouse = a.house
        bHouse = b.house
        if aHouse != bHouse then
          return aHouse < bHouse ? -1 : 1
        else
          return 0
        end
      end
    end

  end
end

