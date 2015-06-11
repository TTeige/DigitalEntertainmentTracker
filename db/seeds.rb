# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

client = TheTvDbParty::Client.new(ENV['TVDB_API_KEY'])
updates = client.get_updates_by_timeframe("week")
updates.series.map do |series|
  user = User.take
  user = User.create(email: "no-user-4242@tempuri.org") unless user
  subscription = SeriesSubscription.find_by :user => user, :seriesid => series[:seriesid]
  unless subscription
    subscription = SeriesSubscription.new :user => user, :seriesid => series[:seriesid]
    subscription.save
  end
end
