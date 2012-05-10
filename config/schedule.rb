# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#

#set :output, logfile

#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

#every :tuesday, :at=>'6:66 pm' do
#  rake '-T'
#end

every :day, :at => '5am, 11am, 5pm, 11pm' do
  rake 'export', :output => File.join(path, "log/#{environment}_export_cron.log")
end
