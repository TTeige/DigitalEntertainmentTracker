# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
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

every 12.hours do
  # Update the cache, set to last update 13 hours ago just to be sure we don't get any weird overlapping issues (if we did 12 hours we could end up with a gap between updates where episodes could escape us).
  runner "ApplicationController.update_cache((Time.new()-13*60*60).to_i)"
end