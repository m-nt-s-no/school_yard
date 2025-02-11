# == Schema Information
#
# Table name: users
#
#  id                      :bigint           not null, primary key
#  email                   :citext           default(""), not null
#  encrypted_password      :string           default(""), not null
#  enrollments_count       :integer          default(0)
#  image                   :string
#  name                    :citext
#  received_messages_count :integer          default(0)
#  remember_created_at     :datetime
#  reset_password_sent_at  :datetime
#  reset_password_token    :string
#  role                    :string
#  sent_messages_count     :integer          default(0)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_name                  (name)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with a valid name, email, password, role' do
    user = User.new(name: 'John Doe', email: 'johndoe@example.com', password: 'password', role: 'teacher')
    expect(user).to be_valid
  end

  it 'is invalid without a name' do
    user = User.new(name: nil, email: 'johndoe@example.com', password: 'password', role: 'teacher')
    expect(user).not_to be_valid
  end

  it 'is invalid without an email' do
    user = User.new(name: 'John Doe', email: nil, password: 'password', role: 'teacher')
    expect(user).not_to be_valid
  end

  it 'is invalid without an password' do
    user = User.new(name: 'John Doe', email: 'johndoe@example.com', password: nil, role: 'guardian')
    expect(user).not_to be_valid
  end

  it 'is invalid without a role' do
    user = User.new(name: 'John Doe', email: 'johndoe@example.com', password: 'password', role: nil)
    expect(user).not_to be_valid
  end

  it 'has a groups_they_lead association with Groups model' do
    user = User.create!(name: 'John Doe', email: 'johndoe@example.com', password: 'password', role: 'teacher')
    new_group = Group.create!(name: 'John\'s group', leader_id: user.id)
    expect(user.groups_they_lead.first).to eq(new_group)
  end

  it 'has a sent_messages association and a received_messages association with Messages model' do
    user = User.create!(name: 'John Doe', email: 'johndoe@example.com', password: 'password', role: 'teacher')
    user2 = User.create!(name: 'Jane Doe', email: 'janedoe@example.com', password: 'password', role: 'guardian')
    new_msg = Message.create!(sender_id: user.id, recipient_id: user2.id, content: "test")
    expect(user.sent_messages.first).to eq(new_msg)
    expect(user2.received_messages.first).to eq(new_msg)
  end

  it 'has an enrollments association with Enrollments model' do
    user = User.create!(name: 'John Doe', email: 'johndoe@example.com', password: 'password', role: 'teacher')
    user2 = User.create!(name: 'Jane Doe', email: 'janedoe@example.com', password: 'password', role: 'guardian')
    test_group = Group.create!(name: 'John\'s group', leader_id: user.id)
    test_enrollment = Enrollment.create!(group_id: test_group.id, user_id: user2.id)
    expect(user2.enrollments.first).to eq(test_enrollment)
    #expect(user2.enrollments.first.group).to eq(test_group) test this in Enrollment spec
  end

  it 'has a membership_groups indirect association with Groups model' do
    user = User.create!(name: 'John Doe', email: 'johndoe@example.com', password: 'password', role: 'teacher')
    user2 = User.create!(name: 'Jane Doe', email: 'janedoe@example.com', password: 'password', role: 'guardian')
    test_group = Group.create!(name: 'John\'s group', leader_id: user.id)
    test_enrollment = Enrollment.create!(group_id: test_group.id, user_id: user2.id)
    expect(user2.membership_groups.first).to eq(test_group)
  end

  it 'has a schedule indirect association with Events model' do
    user = User.create!(name: 'John Doe', email: 'johndoe@example.com', password: 'password', role: 'teacher')
    user2 = User.create!(name: 'Jane Doe', email: 'janedoe@example.com', password: 'password', role: 'guardian')
    test_group = Group.create!(name: 'John\'s group', leader_id: user.id)
    test_enrollment = Enrollment.create!(group_id: test_group.id, user_id: user2.id)
    test_event = Event.create!(name: 'BBQ at John\'s house', starts_at: DateTime.now(), ends_at: 2.hours.from_now, group_id: test_group.id)
    expect(user2.schedule.first).to eq(test_event)
  end
end
