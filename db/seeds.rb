# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
show_list = [
  80379,#TBBT
  82066,#Fringe
  82066,#Fringe
  82459,#The mentalist
  72449 #Stargate
]
show_list.each do |sid|
  SeriesSubscription.create(user_id: 0, seriesid: sid)
end