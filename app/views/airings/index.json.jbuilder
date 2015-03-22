json.array!(@airings) do |airing|
  json.extract! airing, :id, :start_time, :end_time, :listens
  json.url airing_url(airing, format: :json)
end
