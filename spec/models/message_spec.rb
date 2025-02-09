require 'rails_helper'

RSpec.describe Message, type: :model do
  it 'is invalid without content' do
    user = User.create!(name: 'Roger Goodell', email: 'roger@example.com', password: 'password', role: 'teacher')
    user2 = User.create!(name: 'Patrick Mahomes', email: 'pat@example.com', password: 'password', role: 'guardian')
    msg = Message.new(sender_id: user.id, recipient_id: user2.id, content: nil)
    expect(msg).not_to be_valid
  end
end
