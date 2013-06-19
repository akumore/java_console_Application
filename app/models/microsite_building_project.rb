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
      microsite == FELDPARK
    end

    def buenzpark?
      microsite == BUENZPARK
    end

    def gartenstadt?
      microsite == GARTENSTADT
    end
  end

end
