namespace :migrations do
  desc 'Migrate reference keys from real estate to address'
  task :reference_keys => :environment do
    RealEstate.all.each do |real_estate|
      real_estate.address.reference = real_estate.reference
      real_estate.unset :reference
      real_estate.save
    end
  end
end
