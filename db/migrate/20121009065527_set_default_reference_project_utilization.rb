class SetDefaultReferenceProjectUtilization < Mongoid::Migration
  def self.up
    ReferenceProject.all.each do |rp|
      rp.update_attribute :utilization, RealEstate::UTILIZATION_PRIVATE
    end
  end

  def self.down
    ReferenceProject.all.each do |rp|
      rp.update_attribute :utilization, nil
    end
  end
end
