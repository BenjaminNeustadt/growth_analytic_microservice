require 'csv'


def seed_events
  EVENT_TYPES.each do |event_type|

    csv_file_path = event_type

    puts "Seeding trial events from #{csv_file_path}"

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

    puts "Seeding of trial from #{csv_file_path} done.".cyan

  end
end