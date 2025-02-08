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
class Group < ApplicationRecord
  belongs_to :leader, class_name: "User"
  has_many  :events, dependent: :destroy
  has_many  :enrollments, dependent: :destroy
  has_many :members, through: :enrollments, source: :user
end
