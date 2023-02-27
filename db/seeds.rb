require 'colorize'
require_relative './event_seeding.rb'

puts "Seeding...".colorize(:black).on_green
9.times do
  print ".".cyan
  sleep 0.2
end
puts

# TO OMIT AN EVENT TYPE FROM SEEDING COMMENT OUT THE RELEVANT LINE

EVENT_TYPES = 
[
  './db/data/event_trial_data.csv',
  './db/data/event_signup_data.csv'
]

seed_events

puts "Seeding is complete".light_green
