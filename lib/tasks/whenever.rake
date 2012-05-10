namespace :whenever do

  WHENEVER_SET_ENV = "--set 'environment=#{Rails.env}&path=#{Rails.root}'"

  desc <<-DESC
    Update application's crontab entries using Whenever
  DESC
  task :update_crontab do
    sh "whenever -w #{WHENEVER_SET_ENV}"
  end


  desc <<-DESC
    Clear application's crontab entries using Whenever.
  DESC
  task :clear_crontab do
    sh "whenever -c #{WHENEVER_SET_ENV}"
  end
end