class CreateOffices < Mongoid::Migration
  def self.up
    Office.create :label => 'Baar, ZG', :name => 'baar'
    Office.create :label => 'Camorino, TI', :name => 'camorino'
    Office.create :label => 'Marin, NE', :name => 'marin'
  end

  def self.down
    Office.all.map(:destroy)
  end
end
