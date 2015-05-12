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

30.times do |n|
  title  = Faker::Company.catch_phrase
  organization = Faker::Company.name
  contact = Faker::Name.name + "  " + Faker::PhoneNumber.cell_phone
  description = Faker::Lorem.paragraph
  oncampus = n%3 == 0 ? false : true
  islegacy = n%4 == 0 ? false : true
  approved = false	
  Project.create!(title:  title,
                  organization: organization,
                  contact: contact,
                  description: description,
                  oncampus: oncampus,
                  islegacy: islegacy,
       		  approved: approved)
end

20.times do |n|
  title  = Faker::Company.catch_phrase
  organization = Faker::Company.name
  contact = Faker::Name.name + "  " + Faker::PhoneNumber.cell_phone
  description = Faker::Lorem.paragraph
  oncampus = n%3 == 0 ? false : true
  islegacy = n%4 == 0 ? false : true
  approved = true	
  Project.create!(title:  title,
                  organization: organization,
                  contact: contact,
                  description: description,
                  oncampus: oncampus,
                  islegacy: islegacy,
       		  approved: approved)
end

users = User.all


20.times do |n|
  name = Faker::Internet.domain_word
  user_id = users[n].id
  code = "abcd"
  t = Team.create!(name: name, user_id: user_id, code: code)
  Relationship.create!(user_id: user_id, team_id: t.id)
end

teams=Team.all
proj=Project.where("approved = ?", false)
3.times do |n|
  preassign = Preassignment.new do |p|
    p.team_id = teams[n+1].id
    p.project_id = proj[n+1].id
  end
  preassign.save
end

preassign = Preassignment.all
preassign.each do |p|
  preteam = Team.find_by(id: p.team_id)
  teams -= [preteam]
end
projects=Project.where("approved = ?", true)
rnd = Random.new

teams.each do |t|
  #count = 0
  projects.each do |p|
    value = rnd.rand(-1..1)
    #value = 0
    #if count < 5
    #  value = 1
    #elsif count >= 15
    #  value = -1
    #end
    #count += 1
    Preference.create!(team_id: t.id,
		       project_id: p.id,
		       value: value)
  end
end




