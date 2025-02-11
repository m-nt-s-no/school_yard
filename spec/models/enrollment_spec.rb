# == Schema Information
#
# Table name: enrollments
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :integer
#  user_id    :integer
#
# Indexes
#
#  index_enrollments_on_user_id_and_group_id  (user_id,group_id) UNIQUE
#
require 'rails_helper'

RSpec.describe Enrollment, type: :model do
  it "does not the same user to enroll in the same group more than once" do
    user = User.create!(name: 'Andy Reid', email: 'andy@example.com', password: 'password', role: 'teacher')
    user2 = User.create!(name: 'Patrick Mahomes', email: 'pat@example.com', password: 'password', role: 'guardian')
    test_group = Group.create!(name: 'National Football League', leader_id: user.id)
    enrollment = Enrollment.create!(group_id: test_group.id, user_id: user2.id)
    expect {
      Enrollment.create!(group_id: test_group.id, user_id: user2.id)
    }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
