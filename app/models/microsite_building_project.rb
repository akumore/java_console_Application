# encoding: utf-8

module MicrositeBuildingProject

  FELDPARK  = 'feldpark'
  BUENZPARK = 'buenzpark'
  GARTENSTADT = 'gartenstadt'

  def self.all
    [GARTENSTADT, FELDPARK, BUENZPARK]
  end

  module Accessors
    def feldpark?
      microsite_building_project == FELDPARK
    end

    def buenzpark?
      microsite_building_project == BUENZPARK
    end

    def gartenstadt?
      microsite_building_project == GARTENSTADT
    end
  end

end
