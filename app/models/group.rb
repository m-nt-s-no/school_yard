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
  validate :leader_must_be_teacher
  belongs_to :leader, class_name: "User"

  has_many :events, dependent: :destroy
  has_many :past_events, -> { past }, foreign_key: :group_id, class_name: "Event"
  has_many :upcoming_events, -> { upcoming }, foreign_key: :group_id, class_name: "Event"

  has_many :enrollments, class_name: "Enrollment", foreign_key: "group_id", dependent: :destroy
  has_many :members, through: :enrollments, source: :user
  has_many :teacher_members, -> { where(role: "teacher") }, through: :enrollments, source: :user
  has_many :guardian_members, -> { where(role: "guardian") }, through: :enrollments, source: :user
  after_create :create_leader_enrollment

  def leader_must_be_teacher
    user = User.find_by(id: leader_id)
    if user.nil?
      errors.add(:leader_id, "must reference a valid user")
    elsif user.role != "teacher"
      errors.add(:leader_id, "group leader must be a teacher")
    end
  end

  private

  def create_leader_enrollment
    Enrollment.create(group_id: id, user_id: leader_id)
  end
end
