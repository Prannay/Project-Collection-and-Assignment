User.create!(name:  "Administrator",
             email: "admin@example.com",
             password:              "password",
             password_confirmation: "password",
             admin: true)

User.create!(name:  "Jasmeet Singh",
             email: "jasmeet13n@tamu.edu",
             password:              "iiit123",
             password_confirmation: "iiit123",
             admin: false)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end

50.times do |n|
  title  = Faker::Company.catch_phrase
  organization = Faker::Company.name
  contact = Faker::Name.name + "  " + Faker::PhoneNumber.cell_phone
  description = Faker::Lorem.paragraph
  oncampus = n%3 == 0 ? false : true
  islegacy = n%4 == 0 ? false : true
  Project.create!(title:  title,
                  organization: organization,
                  contact: contact,
                  description: description,
                  oncampus: oncampus,
                  islegacy: islegacy)
end

