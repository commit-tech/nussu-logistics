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

# Some random CCAs
SOME_CCAS = ['NUSSU commIT', 'NUSSU VPC', 'IEEE', 'NUS Magic']

# Admin User
admin = User.create(username: 'admin', email: 'admin@example.com',
                    password: '123456', cca: SOME_CCAS[0])
admin.add_role :admin

User::FAKENAMES.each do |c|
  8.times do |i|
    user = User.create(username: "#{c}#{i}", email: "#{c}#{i}@example.com",
                       password: '123456', cca: SOME_CCAS.sample)
  end
end

User.create(username: 'test', email: 'test@example.com', password: '123456', cca: SOME_CCAS[0])

Item.create(name: "Projector", description: "This is a projector", quantity: 2)
Item.create(name: "Camera", description: "This is a camera", quantity: 20)
Item.create(name: "Laptop", description: "This is a laptop", quantity: 3)
