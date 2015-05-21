json.extract! @show, :id, :title, :description
json.djs(@show.djs) do |dj|
  	json.extract! dj, :dj_name
  	json.url dj_url(dj, format: :json)
end
