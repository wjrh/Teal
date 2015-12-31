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
- [ ] put a place to put itunes link in the program
- [ ] write documentation on how to use
- [ ] write documentation on how to contribute
- [ ] write tests
- [ ] go over all javascript objects and remove everything that is not needed
- [ ] implement login system
	- [ ] figure out how to send emails, 
	- [ ] endpoint and method to send email with login link -- this should first check if one is logged in
	- [ ] store login link with with expiration time and email
	- [ ] method to send login link
	- [ ] enpoint to take login link with token
	- [ ] return key and place cookie and redirect
	- [ ] implement pgp encrypted emails through public key copy pase
	- [ ] implement a way to check if the person is properly authenticated and who they are
	- [ ] rack cookies(?)
	- [ ] implement this whole cookie checking process into as a rack middlemant 
- [ ] add organization-like value to program
- [ ] find out if deleting a program deletes all episodes or the episodes just stay or what (testing)
- [ ] make fancy web page with one login/sign up page 
- [ ] make support for cover image

MISC MEDIA UPLOADS
- [ ] make cover image uploadable
- [ ] make image uploadable
- [ ] upload normally, which will return url of the uploaded media
- [ ] POST uploaded media link normally
- [ ] figure out where the misc media goes
- [ ] deal with orphaned data

AUDIO UPLOAD:
- [ ] upload audio file to the endpoint in the episode model
- [ ] have the audio place itself as the first media in that episode
- [ ] figure out where the unencoded audio goes
- [ ] figure out how to trigger encoding of audio
- [ ] figure out where to put the unencoded audio

MEDIA SERVING:
- [ ] serve medias as static files from nginx
- [ ] figure out a way to call the  

DEPLOYMENT:
- [ ] serve teal-live from live.teal.cool
- [ ] serve pure angualar app from app.teal.cool
- [ ] server backend from api.teal.cool
- [ ] serve fancy but static login page from teal.cool. (api will check if one is already logged in and will not send an email but just forward to the app)
- [ ] put nginx in front of everything
	- [ ] have nginx serve the two static apps as static
	- [ ] enable a nginx cache in front of the api

TEAL-LIVE:
websockets to push current song info to whomever wants it
log events trigger changes in the websocket server
we run a socket.io server that listens to events to push
all new events are pushed into the server which then deals with live people
Will listen to the live websocket events and start recording if an episode signals the live-start
When the show ends, the episode will signal live-end and the recording will stop.
will upload the show just like a normal audio upload but without priviladge check

