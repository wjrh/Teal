json.array!(@djs) do |dj|
  json.extract! dj, :id, :net_id, :email, :dj_name, :real_name, :description
  json.url dj_url(dj, format: :json)
end
