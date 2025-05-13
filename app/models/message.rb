# == Schema Information
#
# Table name: messages
#
#  id           :bigint           not null, primary key
#  content      :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  recipient_id :bigint           not null
#  sender_id    :bigint           not null
#
# Indexes
#
#  index_messages_on_recipient_id  (recipient_id)
#  index_messages_on_sender_id     (sender_id)
#
# Foreign Keys
#
#  fk_rails_...  (recipient_id => users.id)
#  fk_rails_...  (sender_id => users.id)
#
class Message < ApplicationRecord
  # NOTE: Good job on the counter_cache
  belongs_to :sender, class_name: "User", counter_cache: :sent_messages_count
  belongs_to :recipient, class_name: "User", counter_cache: :received_messages_count
  validates :content, presence: true
  validate :cannot_send_message_to_self

  private

  def cannot_send_message_to_self
    if sender_id == recipient_id
      errors.add(:sender_id, "cannot send yourself a message")
    end
  end
end
