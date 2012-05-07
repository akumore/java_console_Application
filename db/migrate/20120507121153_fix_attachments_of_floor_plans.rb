class FixAttachmentsOfFloorPlans < Mongoid::Migration

  def self.up
     real_estates = RealEstate.all.select {|r| r.floor_plans.any?}
     real_estates.each do |real_estate|
       new_floor_plans = []
       real_estate.floor_plans.each do |floor_plan|
         new_floor_plans << copy_asset(floor_plan)
       end
 
       new_floor_plans.each do |floor_plan|
         puts "Invalid floor_plan found for real estate #{real_estate.id}" unless floor_plan.valid?
         real_estate.floor_plans << floor_plan
       end
       puts "Copied #{new_floor_plans.size} floor_plans of real estate #{real_estate.id}"
     end
 
     #cleanup
     real_estates = RealEstate.all.select {|r| r.floor_plans.any?}
     real_estates.each do |real_estate|
       real_estate.floor_plans.each do |floor_plan|
         if floor_plan.created_at < (Time.now - 5.minutes)
           puts "Destroying floor_plan #{floor_plan.id}, title: #{floor_plan.title}, created_at: #{floor_plan.created_at} of real estate #{real_estate.id}"
           floor_plan.destroy
         end
       end
     end
  end

  def self.down
    raise Mongoid::IrreversibleMigration.new("Redoing this migration will remove all assets created_at < Time.now - 5.minutes")
  end


  private
  def self.copy_asset(asset)
    MediaAssets::FloorPlan.new extract_asset_params(asset)
  end

  def self.extract_asset_params(asset)
    [:title, :file, :is_primary, :position].inject({}) do |h, attr|
      h[attr] = asset.send(attr) if asset.respond_to?(attr)
      h
    end
  end
  
  
end