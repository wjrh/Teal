json.array!(@songs) do |song|
  json.extract! song, :id, :artist, :title, :ISRC
  json.url song_url(song, format: :json)
end
