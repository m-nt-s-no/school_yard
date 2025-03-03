# == Schema Information
#
# Table name: groups
#
#  id                :bigint           not null, primary key
#  enrollments_count :integer          default(0)
#  name              :citext
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  leader_id         :bigint           not null
#
# Indexes
#
#  index_groups_on_leader_id  (leader_id)
#
# Foreign Keys
#
#  fk_rails_...  (leader_id => users.id)
#
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

  it 'has an association with Enrollments model and automatically creates Enrollment for group leader' do
    user = User.create!(name: 'Saquon Barkley', email: 'saquon@example.com', password: 'password', role: 'teacher')
    test_group = Group.create!(name: 'National Football League', leader_id: user.id)
    expect(test_group.enrollments.first.user_id).to be(user.id)
  end

  it 'does not allow guardians to be group leaders' do
    user = User.create!(name: 'Roger Goodell', email: 'roger@example.com', password: 'password', role: 'guardian')
    expect {
      Group.create!(name: 'National Football League', leader_id: user.id)
    }.to raise_error(ActiveRecord::RecordInvalid, /group leader must be a teacher/)
  end

  it 'has a members indirect association with User model' do
    user = User.create!(name: 'Pete Rozelle', email: 'pete@example.com', password: 'password', role: 'teacher')
    test_group = Group.create!(name: 'National Football League', leader_id: user.id)
    expect(test_group.members).to include(user)
  end

  it 'has a teacher_members indirect association with User model' do
    user = User.create!(name: 'Andy Reid', email: 'andy@example.com', password: 'password', role: 'teacher')
    user2 = User.create!(name: 'Patrick Mahomes', email: 'pat@example.com', password: 'password', role: 'guardian')
    test_group = Group.create!(name: 'National Football League', leader_id: user.id)
    enrollment2 = Enrollment.create!(group_id: test_group.id, user_id: user2.id)
    expect(test_group.teacher_members).to include(user)
    expect(test_group.teacher_members).not_to include(user2)
  end

  it 'has a guardian_members indirect association with User model' do
    user = User.create!(name: 'Jalen Hurts', email: 'jalen@example.com', password: 'password', role: 'teacher')
    user2 = User.create!(name: 'Travis Kelce', email: 'travis@example.com', password: 'password', role: 'guardian')
    test_group = Group.create!(name: 'National Football League', leader_id: user.id)
    enrollment2 = Enrollment.create!(group_id: test_group.id, user_id: user2.id)
    expect(test_group.guardian_members).not_to include(user)
    expect(test_group.guardian_members).to include(user2)
  end
end
