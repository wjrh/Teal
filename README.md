![](http://wjrh.org/teal-logo.png)

Teal is [WJRH](http://wjrh.org)'s DJ-Show-Episode management app, built with Ruby on Rails. It powers the station website for users and the song logger for the DJs. Teal also provides an API endpoint for mobile applications and external data consumption.

## User stories Teal serves:
### Logging / Archiving
 - [ ] As a DJ I want to log my music so that my listeners can see what songs I have played
 - [ ] As a DJ I want to see what songs I have already played so that I do not repeat songs
 - [ ] As a DJ I want to preload a playlist so that logging is quick and easy during my show
 - [ ] As a DJ I want autocomplete function for the logger so that logging is quick and acurate
 - [ ] As a DJ I want to check lyrics of a song before playing so that I comply with FCC regulations
 - [ ] As a DJ I want a 'shazam' style detector so suggest me the current songs so that logging is easy
  
### Live Streaming / Show Information
 - [ ] As a user I want to have a music streamer so that I can lisen to the live radio stream
 - [ ] As a user I want to see what song is playing so that I can see if I want to listen to the radio
 - [ ] As a user I want to see who the DJ is so that if it is my friend I will listen in
 - [ ] As a user I want the current song information to be perfectly synced with the audio stream

### Show Info /  Archive / Log Viewing
 - [ ] As a user I want to view when shows are and what the upcoming shows are
 - [ ] As a user I want to see what songs have already been played so that I have an idea what the show is like 
 - [ ] As a DJ I want to listen to archived versions of my shows so that I can improve my style
 - [ ] As a user I want to see more information about each show so that I can see what show is about and decide if I want to listen
 - [ ] As a user I want to see what the DJ jas played during past shows so that I can userstand the style of the DJ
 - [ ] As a user I want to see a list of all shows and DJs so that I can find a show that interests me

### User DJ Communication
 - [ ] As a DJ I want to communicate with my listeners so that I can change my show based on critiques
 - [ ] As a User I want to recommend songs to the DJ so that I can build relationships 

### About the station
 - [ ] As a user I want to see who's on the staff so that I can see who's in charge
 - [ ] As a user I want to see the contact information so that I can contact a staff member if I want a particular service, join the station, or log a complaint.
 - [ ] As a suer I want to see events the station is hosting so that I can attend events
 - [ ] As a user I want to see when/where the events are being held so that I can attend events
 - [ ] As a user I want to see past events so that I can see what type of events has been hosted

### Administration
 - [ ] As a station administrator I want to post events so that the users know what's happening
 - [ ] As a station administrator I want to update the schedule so that It is always up to date
 - [ ] As a station administrator I want the content to be easily editable
 - [ ] As a station administrator I want to see if shows are happening as planned

### API
 - [ ] As a developer I want to get the current song and dj information
 - [ ] As a developer I want to get the schedule
 - [ ] As a developer I want to get upcoming shows
 - [ ] As a developer I want to get shows
 - [ ] As a developer I want to get djs
 - [ ] As a developer I want to get episodes
 - [ ] As a developer I want to get songs
 - [ ] As a developer I want to get popular shows
 - [ ] As a developer I want to get latest shows
 - [ ] As a developer I want to get streaming links for shows
 - [ ] As a developer I want to get news from the newspaper
 - [ ] As a developer I want to get events

## Todos
### Short term to-do:
- [x] switch to shallow routes (minimal for what we need)
- [ ] restructure index pages in API so that it gives necessary information
- [X] restructure forms to ask for necessary information:
- [x] DJ form
- [x] Show form
- [x] Episode form
- [ ] work on 
- [ ] focus on episode logging essentials (airings)

- [ ] have a system of querying already existing songs when associating songs with episodes

- [ ] create a simple api to view the latest logged song
- [ ] extend that api to include functionality from old PHPs
- [ ] make sure both the new logger and the old logger works (transition)
- [ ] transition to the production server fully working on Tel

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

### lyric checker service
- The dj needs to check the lyrics for profainty of a song before she plays a song

###servers
-icecast
-airtime/airtimedb
-web=teal
-musicbrainz
-storage and listening & processing hard drives
-backups

[![forthebadge](http://forthebadge.com/images/badges/built-with-love.svg)](http://forthebadge.com)

