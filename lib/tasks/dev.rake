desc "Fill the database tables with some sample data"
task({ :render_data => :environment }) do

  Message.destroy_all
  Enrollment.destroy_all
  Event.destroy_all
  Group.destroy_all
  User.destroy_all

  counter = 1
  20.times do
    name = Faker::Movies::Lebowski.character
    first_name = name.split[0]
    user = User.create!(
      name: name, 
      image: Faker::Avatar.image,
      email: "#{first_name}_#{counter}@example.com", 
      password: 'password', 
      role: 'teacher'
    )
    counter += 1
  end

  counter = 1
  50.times do
    name = Faker::Movies::StarWars.character
    first_name = name.split[0]
    user = User.create!(
      name: name, 
      image: Faker::Avatar.image,
      email: "#{first_name}_#{counter}@example.com", 
      password: 'password', 
      role: 'guardian'
    )
    counter += 1
  end

  teacher = User.create!(
    name: "Teacher",
    image: Faker::Avatar.image,
    email: "teacher@example.com", 
    password: 'password', 
    role: 'teacher'
    )

  guardian = User.create!(
    name: "Guardian",
    image: Faker::Avatar.image,
    email: "guardian@example.com", 
    password: 'password', 
    role: 'guardian'
    )

  p "There are #{User.count} users."

  group_names = [
    "Boys' Basketball",
    "Girls' Basketball",
    "Varsity Football",
    "Track and Field",
    "Science Club",
    "Quiz Bowl Team",
    "Spelling Bee",
    "Mathletes",
    "Volunteering Club",
    "Student Council",
    "Prom Committee",
    "Spring Talent Show"
  ]
  teachers = User.where(:role => "teacher")
  teacher_count = teachers.count
  group_counter = 0
  group_names.count.times do
    group = Group.create!(
      name: group_names[group_counter],
      leader_id: teachers[rand(teacher_count)].id
    )
    group_counter += 1
    rand(1..6).times do
      rand_user = User.all.sample
      if rand_user != group.leader
        enrollment = Enrollment.create!(
          group_id: group.id,
          user_id: rand_user.id
        )
      end   
    end              
  end
  p "There are #{Group.count} groups."
  p "There are #{Enrollment.count} enrollments."

  36.times do
    start_time = Faker::Time.between(from: DateTime.now - 30, to: DateTime.now + 30)
    end_time = start_time + 3600
    event = Event.create!(
      name: Faker::Lorem.sentence(word_count: 3), 
      starts_at: start_time, 
      ends_at: end_time, 
      group_id: Group.all.sample.id
    )
  end
  p "There are #{Event.count} events."

  users = User.all
  users.each do |user1|
    users.each do |user2|
      rand_value = [true, false].sample
      if (user1 != user2) && (rand_value == true)
        msg = Message.create!(
          recipient_id: user1.id,
          sender_id: user2.id,
          content: Faker::Lorem.sentence(word_count: 6)
        )
      end
    end
  end
  p "There are #{Message.count} messages."
end

task({ :sample_data => :environment }) do

  if Rails.env.development?
    Message.destroy_all
    Enrollment.destroy_all
    Event.destroy_all
    Group.destroy_all
    User.destroy_all
  end

  counter = 1
  12.times do
    name = Faker::Movies::Lebowski.character
    first_name = name.split[0]
    user = User.create!(
      name: name, 
      image: Faker::Avatar.image,
      email: "#{first_name}_#{counter}@example.com", 
      password: 'password', 
      role: ['teacher', 'guardian'].sample
    )
    counter += 1
  end

  max = User.create!(
    name: "Max",
    image: Faker::Avatar.image,
    email: "max@example.com", 
    password: 'password', 
    role: 'teacher'
    )

  p "There are #{User.count} users."

  12.times do
    teachers = User.where(:role => "teacher")
    teacher_count = teachers.count
    group = Group.create!(
      name: Faker::Sports::Football.team,
      leader_id: teachers[rand(teacher_count)].id
    )                               
  end
  p "There are #{Group.count} groups."

  User.all.each do |user|
    seen = []
    rand(1..4).times do
      group = Group.all.sample
      if (!seen.include?(group.name)) && (user != group.leader)
        enrollment = Enrollment.create!(
          group_id: group.id,
          user_id: user.id
        )
        seen.push(group.name)
      end
    end
  end
  p "There are #{Enrollment.count} enrollments."

  24.times do
    start_time = Faker::Time.between(from: DateTime.now - 30, to: DateTime.now + 30)
    end_time = start_time + 3600
    event = Event.create!(
      name: Faker::Lorem.sentence(word_count: 3), 
      starts_at: start_time, 
      ends_at: end_time, 
      group_id: Group.all.sample.id
    )
  end
  p "There are #{Event.count} events."

  users = User.all
  users.each do |user1|
    users.each do |user2|
      if user1 != user2
        msg = Message.create!(
          recipient_id: user1.id,
          sender_id: user2.id,
          content: Faker::Lorem.sentence(word_count: 6)
        )
      end
    end
  end
  p "There are #{Message.count} messages."
end
