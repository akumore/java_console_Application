# encoding: utf-8

module Microsite
  class SortRealEstates

    def self.sort a, b
      aGroupSortKey = a.group_sort_key
      bGroupSortKey = b.group_sort_key
      if aGroupSortKey != bGroupSortKey then
        return aGroupSortKey <=> bGroupSortKey
      else
        aHouse = a.house
        bHouse = b.house
        if aHouse != bHouse then
          return aHouse < bHouse ? 1 : -1
        else
          return 0
        end
      end
    end

  end
end

