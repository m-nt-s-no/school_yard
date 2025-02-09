require 'rails_helper'

RSpec.describe Group, type: :model do
  it 'is invalid without a name' do
    user = User.create!(name: 'Roger Goodell', email: 'roger@example.com', password: 'password', role: 'teacher')
    group = Group.new(name: nil, leader_id: user.id)
    expect(group).not_to be_valid
  end

  it 'is invalid without a leader' do
    user = User.create!(name: 'Roger Goodell', email: 'roger@example.com', password: 'password', role: 'teacher')
    group = Group.new(name: 'NFL', leader_id: nil)
    expect(group).not_to be_valid
  end

  it 'has an events association with Events model' do
    user = User.create!(name: 'Roger Goodell', email: 'roger@example.com', password: 'password', role: 'teacher')
    test_group = Group.create!(name: 'National Football League', leader_id: user.id)
    event = Event.create!(name: 'Super Bowl', starts_at: Time.now(), ends_at: 4.hours.from_now, group_id: test_group.id)
    expect(test_group.events).to include(event)
  end

  it 'has a past_events association with Events model' do
    user = User.create!(name: 'Roger Goodell', email: 'roger@example.com', password: 'password', role: 'teacher')
    test_group = Group.create!(name: 'National Football League', leader_id: user.id)
    event = Event.create!(name: 'Super Bowl', starts_at: 2.days.ago, ends_at: 1.day.ago, group_id: test_group.id)
    expect(test_group.past_events).to include(event)
  end

  it 'has an upcoming_events association with Events model' do
    user = User.create!(name: 'Roger Goodell', email: 'roger@example.com', password: 'password', role: 'teacher')
    test_group = Group.create!(name: 'National Football League', leader_id: user.id)
    event = Event.create!(name: 'Super Bowl', starts_at: 1.day.from_now, ends_at: 2.days.from_now, group_id: test_group.id)
    expect(test_group.upcoming_events).to include(event)
  end

  it 'has an association with Enrollments model' do
    user = User.create!(name: 'Roger Goodell', email: 'roger@example.com', password: 'password', role: 'teacher')
    test_group = Group.create!(name: 'National Football League', leader_id: user.id)
    enrollment = Enrollment.create!(group_id: test_group.id, user_id: user.id)
    expect(test_group.enrollments.first.user_id).to be(user.id)
  end

  it 'has a members indirect association with User model' do
    user = User.create!(name: 'Roger Goodell', email: 'roger@example.com', password: 'password', role: 'teacher')
    test_group = Group.create!(name: 'National Football League', leader_id: user.id)
    enrollment = Enrollment.create!(group_id: test_group.id, user_id: user.id)
    expect(test_group.members).to include(user)
  end

  it 'has a teacher_members indirect association with User model' do
    user = User.create!(name: 'Roger Goodell', email: 'roger@example.com', password: 'password', role: 'teacher')
    user2 = User.create!(name: 'Patrick Mahomes', email: 'pat@example.com', password: 'password', role: 'guardian')
    test_group = Group.create!(name: 'National Football League', leader_id: user.id)
    enrollment = Enrollment.create!(group_id: test_group.id, user_id: user.id)
    enrollment2 = Enrollment.create!(group_id: test_group.id, user_id: user2.id)
    expect(test_group.teacher_members).to include(user)
    expect(test_group.teacher_members).not_to include(user2)
  end

  it 'has a guardian_members indirect association with User model' do
    user = User.create!(name: 'Roger Goodell', email: 'roger@example.com', password: 'password', role: 'teacher')
    user2 = User.create!(name: 'Patrick Mahomes', email: 'pat@example.com', password: 'password', role: 'guardian')
    test_group = Group.create!(name: 'National Football League', leader_id: user.id)
    enrollment = Enrollment.create!(group_id: test_group.id, user_id: user.id)
    enrollment2 = Enrollment.create!(group_id: test_group.id, user_id: user2.id)
    expect(test_group.guardian_members).not_to include(user)
    expect(test_group.guardian_members).to include(user2)
  end
end
