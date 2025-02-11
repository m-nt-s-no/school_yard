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
require 'rails_helper'

RSpec.describe Message, type: :model do
  it 'is invalid without content' do
    user = User.create!(name: 'Roger Goodell', email: 'roger@example.com', password: 'password', role: 'teacher')
    user2 = User.create!(name: 'Patrick Mahomes', email: 'pat@example.com', password: 'password', role: 'guardian')
    msg = Message.new(sender_id: user.id, recipient_id: user2.id, content: nil)
    expect(msg).not_to be_valid
  end

  it 'does not allow users to send messages to themselves' do
    user = User.create!(name: 'Jalen Hurts', email: 'andy@example.com', password: 'password', role: 'teacher')
    msg = Message.new(content: "Congratulations!", sender_id: user.id, recipient_id: user.id)
    expect(msg).not_to be_valid
  end
end
