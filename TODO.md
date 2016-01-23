- [ ] implement the language etc extra features feature (as well as category)
- [x] implement the copyright feature to the front end
- [x] implement manual media saving to the front end
- [ ] implement a email subscriber list system
	- [ ] make a system to subscribe using simple html forms
	- [ ] make a systesm to unsubscribe using simple html form
	- [ ] make a subscriber embeded documents
	- [ ] store subscribers in the subscribers list
	- [ ] store a random key in the subscribers list for unsubscription
	- [ ] method to subscribe
	- [ ] method to confirm subscription with key and email
	- [ ] method to unsubscribe with key and email
- [?] put a place to put itunes link in the program
- [ ] write documentation on how to use
- [ ] write documentation on how to contribute
- [ ] write tests
- [~] go over all json objects and remove everything that is not needed
- [x] implement login system
	- [x] figure out how to send emails, 
	- [x] endpoint and method to send email with login link -- this should first check if one is logged in
	- [x] store login link with with expiration time and email
	- [x] method to send login link
	- [x] enpoint to take login link with token
	- [x] return key and place cookie and redirect
  - [ ] authenticate using keys
	- [ ] implement pgp encrypted emails through public key copy pase
	- [x] implement a way to check if the person is properly authenticated and who they are
	- [x] rack cookies(?)
	- [x] implement this whole cookie checking process into as a rack middlemant 
- [ ] add organization-like value to program for live notifs
- [ ] login improvements
	- [ ] move email verified people mongo for key and cookie tracking
	- [ ] expire cookies using timestamp checks from mongo
	- [C] move cookies to a redis based setup -- this eliminates key rotation or never expiring cookie problem
- [ ] find out if deleting a program deletes all episodes or the episodes just stay or what (testing)
- [ ] make fancy web page with one login/sign up page 
- [ ] make support for cover image and other attributes
- [ ] dont display non-pubdate passed episodes
- [ ] only display non-pubdate passed episodes to logged in people
- [ ] use secure random to generate uuids - but save vbbs guids.
- [ ] enforce itunes podcast spec character limits
- [ ] add hyperlinks in models (i.e. provide links with further information on objects)

MISC MEDIA UPLOADS
- [ ] make cover image uploadable
- [ ] make image uploadable
- [ ] upload normally, which will return url of the uploaded media
- [ ] POST uploaded media link normally
- [ ] figure out where the misc media goes
- [ ] deal with orphaned data

AUDIO UPLOAD:
- [ ] upload audio file to a main endpoint/shortname
- [ ] have the audio place itself as the first media in that episode
- [ ] figure out where the unencoded audio goes
- [ ] figure out how to trigger encoding of audio (redis?)
- [ ] figure out where to put the unencoded audio
- [ ] deal with orphaned media(?)

MEDIA SERVING:
- [ ] serve medias as static files from nginx
- [ ] figure out a way to call the download counter

DEPLOYMENT:
- [ ] serve teal-live from live.teal.cool
- [ ] serve pure angualar app from app.teal.cool
- [ ] server backend from api.teal.cool
- [ ] serve fancy but static login page from teal.cool. (api will check if one is already logged in and will not send an email but just forward to the app)
- [ ] put nginx in front of everything
	- [ ] have nginx serve the two static apps as static
	- [ ] enable a nginx cache in front of the api
- move all http to https

TEAL-LIVE:
websockets to push current song info to whomever wants it
log events trigger changes in the websocket server
we run a socket.io server that listens to events to push
all new events are pushed into the server which then deals with live people
Will listen to the live websocket events and start recording if an episode signals the live-start
When the show ends, the episode will signal live-end and the recording will stop.
will upload the show just like a normal audio upload but without priviladge check

