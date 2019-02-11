# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database
# with its default values.
# The data can then be loaded with the rails db:seed command (or created
# alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' },
#                          { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Admin User
admin = User.create(username: 'admin', email: 'admin@example.com',
                    password: '123456')
admin.add_role :admin

User::FAKENAMES.each do |c|
  8.times do |i|
    user = User.create(username: "#{c}#{i}", email: "#{c}#{i}@example.com",
                       password: '123456')
  end
end

User.create(username: 'test', email: 'test@example.com', password: '123456')

('12:00'.in_time_zone.to_i..'16:00'.in_time_zone.to_i)
  .step(2.hours).each do |time|
  start = Time.zone.at(time)
  TimeRange.create(start_time: start, end_time: start + 2.hours)
end

# Timeslots in YIH
Date::DAYNAMES.each do |day|
  TimeRange.all.each do |tr|
    Timeslot.create(day: day,
                    default_user: User.offset(rand(User.count)).first,
                    time_range: tr)
  end
end
