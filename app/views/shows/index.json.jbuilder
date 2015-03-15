json.show do
  @shows.each{ |issue| json.set! show.title, issue.description, show.djs }
end