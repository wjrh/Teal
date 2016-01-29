- [2] implement a email subscriber list system
	- [2] make a system to subscribe using simple html forms
	- [2] make a systesm to unsubscribe using simple html form
	- [2] make a subscriber embeded documents
	- [2] store subscribers in the subscribers list
	- [2] store a random key in the subscribers list for unsubscription
	- [2] method to subscribe
	- [2] method to confirm subscription with key and email
	- [2] method to unsubscribe with key and email
- [2] write documentation on how to use
- [2] write documentation on how to contribute
- [2] write tests
- [~] go over all json objects and remove everything that is not needed
- [x] implement login system
	- [x] figure out how to send emails, 
	- [x] endpoint and method to send email with login link -- this should first check if one is logged in
	- [x] store login link with with expiration time and email
	- [x] method to send login link
	- [x] enpoint to take login link with token
	- [x] return key and place cookie and redirect
	- [x] implement a way to check if the person is properly authenticated and who they are
	- [x] rack cookies(?)
	- [x] implement this whole cookie checking process into as a rack middlemant 
- [ ] add organization-like value to program for live notifs
- [ ] login improvements
	- [ ] move email verified people mongo for key and cookie tracking
	- [2] expire cookies using timestamp checks from mongo
	- [2] implement pgp encrypted emails through public key copy pase
  - [2] authenticate using keys
	- [C] move cookies to a redis based setup -- this eliminates key rotation or never expiring cookie problem
- [ ] find out if deleting a program deletes all episodes or the episodes just stay or what (testing)
- [ ] make fancy web page with one login/sign up page 
- [ ] make support for cover image and other attributes
- [ ] dont display non-pubdate passed episodes
- [ ] only display non-pubdate passed episodes to logged in people
- [ ] use secure random to generate uuids - but save vbbs guids.
- [2] enforce itunes podcast spec character limits
- [2] add hyperlinks in models (i.e. provide links with further information on objects)
- [ ] implement the language etc extra features feature (as well as category)

AUDIO UPLOADS
- [ ] use GridFS
- [ ] upload into GridFS
- [ ] uploaded file goes directly to the episode
- [ ] the uploaded file is marked raw and unprocessed
- [ ] outside process processes the takes the file, processes it, places the processed tab and metadata in the episode
- [ ] outside process markes raw file processed

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
- [ ] record download stats into mongodb which can be made downloadable later

DEPLOYMENT:
- [ ] serve pure angualar app from teal.cool which is also the fancy login page.
- [ ] api will check if one is already logged in and will not send an email but just foreard to the app
- [ ] server backend from api.teal.cool

TEAL-LIVE:
websockets to push current song info to whomever wants it
- [ ] serve teal-live from live.teal.cool
log events trigger changes in the websocket server
we run a socket.io server that listens to events to push
all new events are pushed into the server which then deals with live people
Will listen to the live websocket events and start recording if an episode signals the live-start
When the show ends, the episode will signal live-end and the recording will stop.
will upload the show just like a normal audio upload but without priviladge check

