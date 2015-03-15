json.album do
  json.title    @currentshow.title
  json.description @currentshow.description

  json.djs @currentshow.djs
end