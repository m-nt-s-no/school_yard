require 'rails_helper'

RSpec.describe Event, type: :model do
  it 'is valid with a valid name, start time, end time, and group_id' do
    user = User.create!(name: 'Roger Goodell', email: 'roger@example.com', password: 'password', role: 'teacher')
    test_group = Group.create!(name: 'National Football League', leader_id: user.id)
    event = Event.create!(name: 'Super Bowl', starts_at: Time.now(), ends_at: 4.hours.from_now, group_id: test_group.id)
    expect(event).to be_valid
  end

  it 'is invalid without a name' do
    user = User.create!(name: 'Roger Goodell', email: 'roger@example.com', password: 'password', role: 'teacher')
    test_group = Group.create!(name: 'National Football League', leader_id: user.id)
    event = Event.new(name: nil, starts_at: Time.now(), ends_at: 4.hours.from_now, group_id: test_group.id)
    expect(event).not_to be_valid
  end

  it 'is invalid without a start time' do
    user = User.create!(name: 'Roger Goodell', email: 'roger@example.com', password: 'password', role: 'teacher')
    test_group = Group.create!(name: 'National Football League', leader_id: user.id)
    event = Event.new(name: 'Super Bowl', starts_at: nil, ends_at: 4.hours.from_now, group_id: test_group.id)
    expect(event).not_to be_valid
  end

  it 'is invalid without an end time' do
    user = User.create!(name: 'Roger Goodell', email: 'roger@example.com', password: 'password', role: 'teacher')
    test_group = Group.create!(name: 'National Football League', leader_id: user.id)
    event = Event.new(name: 'Super Bowl', starts_at: 4.hours.from_now, ends_at: nil, group_id: test_group.id)
    expect(event).not_to be_valid
  end

  it 'has a past scope to identify events that have ended' do
    user = User.create!(name: 'Roger Goodell', email: 'roger@example.com', password: 'password', role: 'teacher')
    test_group = Group.create!(name: 'National Football League', leader_id: user.id)
    event = Event.create!(name: 'Super Bowl', starts_at: 4.hours.ago, ends_at: 1.hours.ago, group_id: test_group.id)
    expect(Event.past).to include(event)
  end

  it 'has an upcoming scope to identify events that have not started' do
    user = User.create!(name: 'Roger Goodell', email: 'roger@example.com', password: 'password', role: 'teacher')
    test_group = Group.create!(name: 'National Football League', leader_id: user.id)
    event = Event.create!(name: 'Super Bowl', starts_at: 4.hours.from_now, ends_at: 8.hours.from_now, group_id: test_group.id)
    expect(Event.upcoming).to include(event)
  end
end
