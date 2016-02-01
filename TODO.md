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
- [2] redirect people if the redirect url is set
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
- [x] add organization-like value to program for live notifs
- [ ] login improvements
	- [ ] move email verified people mongo for key and cookie tracking
	- [2] expire cookies using timestamp checks from mongo
	- [2] implement pgp encrypted emails through public key copy pase
  - [2] authenticate using keys
	- [C] move cookies to a redis based setup -- this eliminates key rotation or never expiring cookie problem
- [x] find out if deleting a program deletes all episodes or the episodes just stay or what (testing)
- [ ] make fancy web page with one login/sign up page 
- [ ] move frontend to the repo
- [x] make support for cover image and other attributes
- [x] dont display non-pubdate passed episodes
- [x] only display non-pubdate passed episodes to logged in people
- [x] use secure random to generate uuids - but save vbbs guids.
- [2] enforce itunes podcast spec character limits
- [2] add hyperlinks in models (i.e. provide links with further information on objects)
- [x] implement the language etc extra features feature (as well as category)

AUDIO UPLOADS and SERVING
- [ ] upload happens
- [ ] file is placed in the raw folder in the media folder with the filename:episode id
- [ ] file is placed in the processed folder with the filename: episode id.mp3
- [ ] when a new upload is complete, the id is added to the queue for processing
- [ ] resque worker processes the upload and when complete, puts the url of where it can be found (predictable as it is by id)
- [ ] there is a url like api.teal.cool/media.mp3?id=234523234 which returns the file (for now --  will see if its a perf problem)
- [ ] this url also records all accesses to the file with their range requests (need to figure out what to log)

MISC MEDIA UPLOADS
- [ ] make cover image uploadable
- [ ] make image uploadable
- [ ] upload normally, which will return url of the uploaded media
- [ ] POST uploaded media link normally
- [ ] figure out where the misc media goes
- [ ] deal with orphaned data

AUDIO UPLOAD:
- [ ] upload audio file to a main endpoint/shortname

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

