Teal
====

Teal runs WJRH.

![](http://wjrh.org/teal_sharpie.jpg)

### Short term to-do:
- [x] switch to shallow routes (minimal for what we need)
- [ ] restructure index pages in API so that it gives necessary information
- [ ] restructure forms to ask for necessary information:
- [x] DJ form
- [x] Show form
- [x] Episode form
- [ ] focus on episode logging essentials (airings)


- [ ] have a system of querying already existing songs when associating songs with episodes

- [ ] create a simple api to view the latest logged song
- [ ] extend that api to include functionality from old PHPs
- [ ] make sure both the new logger and the old logger works (transition)
- [ ] transition to the production server fully working on Teal
- [ ] add static content/pages to the website

- [ ] SSO w/ lafayette

- [ ] autocomplete on the episode/song logger page! (Musicbrainz, JS)

- [ ] Implement profile picures for shows and djs

- [ ] start rolling out/testing with real DJs
- [ ] Start using vanity urls for shows and djs. (descriptive url)

### Shows view:
- [ ] make page to view all shows
- [ ] make a way for people to modify their own shows
- [ ] shows will have profile pictures that are resized for mobile and web
- [ ] show descriptions and images are mandatory

### Top lists view:
- [ ] make a way to view top songs that week/month
- [ ] add an json api way of accessing the data as well
- [ ] add cover art information from Musicbrainz (maybe consider adding it to songs)

### Popularity view:
- [ ] collect listener information from icecast and put max listeners to episode/airing
- [ ] feature shows depending on their popularity on the home page
- [ ] sort "most popular" shows/episodes and display them.

### Real time feedback:
- [ ] delay the song information by 12 seconds so that it is fully synced
- [ ] indicate the delay in some way to the DJ
- [ ] implement something like a like button so that the DJ can feel good

### Recording Shows
- [ ] record shows and commit them into the db with a recording url
- [ ] connect the record action to the logging and make it clear that it is being recorded.
