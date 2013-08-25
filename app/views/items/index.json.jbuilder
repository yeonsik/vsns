json.array!(@items) do |item|
  json.extract! item, :user_id, :photo, :url_ref, :description, :starts_count
  json.url item_url(item, format: :json)
end
