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
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  enum role: {guardian: "guardian", teacher: "teacher"}

  has_many :groups, class_name: "Group", foreign_key: "leader_id"
end
