# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Plan.create name: "SPORTS PACKAGE (1 Week)", price: 50, recurring: true, period: "Week", cycles: 52, duration: 1, plan_id: 1
Plan.create name: "SPORTS PACKAGE (1 Month)", price: 150, recurring: true, period: "Month", cycles: 52, duration: 1, plan_id: 2
Plan.create name: "SPORTS PACKAGE (1 Quarter)", price: 400, recurring: true, period: "Month", cycles: 52, duration: 3, plan_id: 3
Plan.create name: "SPORTS PACKAGE (1 Year)", price: 1300, recurring: true, period: "Year", cycles: 52, duration: 1, plan_id: 4
