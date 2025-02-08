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
class Enrollment < ApplicationRecord
  belongs_to :user, counter_cache: true
  belongs_to :group, counter_cache: true
end
