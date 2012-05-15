desc 'run post-deployment tasks'

task :post_deploy do
  puts 'Precompiling assets'
  Rake::Task["assets:precompile"].invoke

  puts 'Writing cronjobs'
  Rake::Task["whenever:update_crontab"].invoke

  puts 'Restarting thin servers'
  Rake::Task["thin:restart"].invoke
end
