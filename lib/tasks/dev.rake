desc "Fill the database tables with some sample data"
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
