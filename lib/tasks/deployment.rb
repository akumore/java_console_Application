desc 'run post-deployment tasks'
task :post_deploy do
  puts 'Restarting thin servers'
  Rake::Task["thin:restart"].invoke
end