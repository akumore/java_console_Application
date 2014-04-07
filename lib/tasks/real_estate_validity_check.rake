namespace :db do
  desc 'prints all invalid real estates'

  task :validate_real_estates => :environment do
    RealEstate.all.reject { |r| r.valid? }.each do |real_estate|
      if Rails.env.production?
        puts "http://www.alfred-mueller.ch/cms/real_estates/#{real_estate.id}"
      elsif Rails.env.staging?
        puts "http://alfredmueller-web-staging.c3.screenconcept.ch/cms/real_estates/#{real_estate.id}"
      end
    end
  end
end
