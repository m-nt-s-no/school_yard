json.extract! event, :id, :name, :group_id, :starts_at, :address, :notes, :ends_at, :created_at, :updated_at
json.url event_url(event, format: :json)
