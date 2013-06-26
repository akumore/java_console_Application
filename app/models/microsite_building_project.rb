# encoding: utf-8

module MicrositeBuildingProject

  FELDPARK  = 'feldpark'
  BUENZPARK = 'buenzpark'
  GARTENSTADT = 'gartenstadt'

  def self.all
    [GARTENSTADT, FELDPARK, BUENZPARK]
  end
end
