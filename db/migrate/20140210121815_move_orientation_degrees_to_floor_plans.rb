class MoveOrientationDegreesToFloorPlans < Mongoid::Migration
  def self.up
    RealEstate.all.each do |re|
      if re.additional_description
        if re.additional_description.orientation_degrees
          orientation = re.additional_description.orientation_degrees
          re.floor_plans.each {|fp|
            fp.update_attributes(orientation_degrees: orientation)
          }
        end

        re.unset('additional_description')
      end
    end
  end

  def self.down
  end
end
