json.array!(@episodes) do |episode|
  json.extract! episode, :id, :name, :recording_url, :downloadable, :online_listens
  json.url episode_url(episode, format: :json)
end
