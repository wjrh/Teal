json.array!(@shows) do |show|
  json.extract! show, :id, :title, :description
  json.url show_url(show, format: :json)
end
