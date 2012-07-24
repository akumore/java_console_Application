desc 'run post-deployment tasks'

task :post_deploy do
  puts 'Migrate DB'
  Rake::Task["db:migrate"].invoke

  puts 'Precompiling assets'
  Rake::Task["assets:precompile"].invoke

  puts 'Writing cronjobs'
  Rake::Task["whenever:update_crontab"].invoke

  puts 'Restarting thin servers'
  Rake::Task["thin:restart"].invoke

  if Rails.env.production?
    puts 'Notifiying campfire'
    Rake::Task["sc:campfire:notify"].invoke
  end
end
