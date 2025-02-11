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
class Enrollment < ApplicationRecord
  belongs_to :user, counter_cache: true
  belongs_to :group, counter_cache: true
  validates :user_id, uniqueness: { scope: :group_id, message: "User is already enrolled" }
end
