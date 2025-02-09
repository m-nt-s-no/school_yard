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
  validates :name, presence: true
  belongs_to :leader, class_name: "User"
  has_many :events, dependent: :destroy
  has_many :past_events, -> { past }, foreign_key: :group_id, class_name: "Event"
  has_many :upcoming_events, -> { upcoming }, foreign_key: :group_id, class_name: "Event"
  has_many :enrollments, class_name: "Enrollment", foreign_key: "group_id", dependent: :destroy
  has_many :members, through: :enrollments, source: :user
  has_many :teacher_members, -> { where(role: "teacher") }, through: :members,  source: :user
  has_many :guardian_members, -> { where(role: "guardian") }, through: :members, source: :user
end
