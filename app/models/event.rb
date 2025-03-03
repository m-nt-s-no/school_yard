# == Schema Information
#
# Table name: events
#
#  id         :bigint           not null, primary key
#  address    :string
#  ends_at    :datetime
#  name       :citext           default(""), not null
#  notes      :text
#  starts_at  :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :bigint           not null
#
# Indexes
#
#  index_events_on_group_id  (group_id)
#
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id)
#
class Event < ApplicationRecord
  belongs_to :group
  has_one  :leader, through: :group, source: :users
  scope :past, -> {where('ends_at < ?', Time.now)}
  scope :upcoming, -> {where('starts_at > ?', Time.now)}
  validates :name, presence: true
  validates :starts_at, presence: true
  validates :ends_at, presence: true
end
