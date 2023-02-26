require 'csv'

def seed_signup_events
  csv_file_path = './db/data/signup_event_data.csv'

  puts "Seeding signup events from #{csv_file_path}"

  file = File.new(csv_file_path, 'r')
  csv = CSV.new(file)
  headers = csv.shift

  csv.each do |row|
    data = {
      name:        row[0],
      fingerprint: row[1],
      user_id:     row[2],
      created_at:  row[3]
    }
    event = Event.create(data)
  end

  puts "Seeding of events from #{csv_file_path} done."
end