require 'colorize'
require_relative './signup_event_seeding.rb'

puts "Seeding...".colorize(:black).on_green
9.times do
  print ".".cyan
  sleep 0.2
end
puts

# To omit specific events from seeding comment the relevant line
seed_signup_events
seed_trial_events

puts "Seeding is complete".light_green
