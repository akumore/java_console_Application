namespace :db do

  desc <<-DESC
    Backups the database for the current Rails.env to db/backups
  DESC
  task :backup do
    config = Mongoid.load!(Rails.root.join('config/mongoid.yml'))
    host_option = "-h #{[config['host'].presence, config['port'].presence].compact.join(':')}"
    database_option = "-d #{config['database']}"
    user_option = "-u #{config['username']}" if config['username'].present?
    password_option = "-p #{config['password']}" if config['password'].present?

    dir_name = "#{Rails.env}-db-#{Time.now.strftime("%Y%m%d")}-#{Time.now.to_i}"
    dir_option = "-o #{Rails.root.join('db', 'backups', dir_name)}"

    sh ['mongodump', host_option, database_option, user_option, password_option, dir_option].compact.join(" ")
  end
end
