json.array!(@djs) do |dj|
  json.extract! dj, :id, :dj_name, :real_name
  json.url dj_url(dj, format: :json)
end
