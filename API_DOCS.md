## API Documentation
### Hostname, HTTPS and request/response format
All API requests are made to the hostname `https://api.teal.cool`. An API response is not guaranteed when using HTTP. Teal is configured to use [modern ciphers only](https://mozilla.github.io/server-side-tls/ssl-config-generator/?server=nginx-1.9.5&openssl=1.0.1e&hsts=yes&profile=modern) with HTTPS. Oldest compatible clients are Firefox 27, Chrome 30, IE 11 on Windows 7, Edge, Opera 17, Safari 9, Android 5.0, and Java 8.

Request and response format will be composed of only the object (dictionary) or collection (array) requested. Except for the XML feeds, all responses will be in JSON format.

### Rate Limiting/Bursting

The API enforces a rate limit of 4 requests/sec per IP. Bursting is provided as a convenience before requests are rejected with a 503 status code.

### Authentication and Authorization


#### Authentication
Authentication is required for performing create, update or delete actions, but not required to read. Some meta information (such as owners for programs) will be provided to authenticated and authorized users and not to others. Episodes that have upcoming publishing dates also will only be shown to authenticated and authorized users.

Every account is authenticated over email:

```
curl -X POST -d '{"email":"<YOUR EMAIL>"}' https://api.teal.cool/login
```

or using the shortcut version:

```
curl -X POST https://api.teal.cool/login?email=<YOUR EMAIL>
```

The login method will not return any useful information. Once an email is sent, it will expire in 8 minutes. During this time, you can not request an other authentication email.

When you open your email account you will see an email from login@teal.cool. Upon following this link, you will be logged in to the web interface. Your key will be accessible at `api.teal.cool/key` from your browser. Note that every time you request a key, the old one will be invalidated.

You can also choose only to get your key directly without the web interface.

```
curl https://api.teal.cool/auth?token=aZ3vNUb0Rjm7gBK4BeBjgg
```

API keys will never expire but every successful login will generate a new one.

#### Authorization
To perform privileged actions, you will need to call requests with the `teal-api-key` HTTP header. Alternatively you can call it with a cookie that was passed on authentication. If successful, all authenticated responses will return the `teal-logged-in-as` HTTP header. 

Calling `api.teal.cool/whoami` will return the email of the currently logged in user.

Authorization on Teal is done either using cookies or keys passed through request headers. API key takes precedence if both is used.

General rule to remember about authorization is that most things are public as you create the records and you can change Programs, Episodes and Tracks only if you're one of the owners.


### Models
Program is the only top level model. A program can have many episodes, an episode can have many tracks. When a program is returned, a an array of its episodes are also returned in abbreviated form. When an episode is returned by itself, it is returned with an abbreviated form of its program and all of its tracks.

#### Program
A program looks like this:

```
{
	"active": true,
	"author": "Ted and Renan",
	"copyright": "Renan and Ted",
	"cover_image": "http://i.imgur.com/Lcychlc.png",
	"description": "An overall great program!",
	"image": "http://i.imgur.com/1iQ6U4d.png",
	"itunes_categories": null,
	"language": "en-us",
	"name": "DD-MM-YYYY",
	"organizations": ["WJRH"],
	"owners": ["renandincer@gmail.com"],
	"redirect_url": null,
	"scheduled_time": null,
	"shortname": "sendnudes",
	"stream": "listen.wjrh.org",
	"subtitle": "Ted and Renan play music",
	"tags": ["music"],
	"explicit": false,
	"id": "56e7675ce2b026000a0ec5f6",
	"episodes": [...]
}
```

 A program's episodes is returned (not shown above) with some details left out as a part of a program. The `id` attribute from the program can be used to request the full episode object
 
#### Episode
An episode looks like this:

```
{
	"audio_url": "http://api.teal.cool/download/56e76edfc49c530010f9a2e5.mp3",
	"description": "Ted really likes his Jazz. Ted's friend Kate calls in. Ted likes cheese? Everyone's happy today.",
	"end_time": "2016-03-15T03:02:41.824+00:00",
	"guid": "025de47f-52e4-47ad-80d1-87164094150c",
	"image": null,
	"length": "3212",
	"name": "14-03-2016",
	"pubdate": "2016-03-15T02:09:25.228+00:00",
	"start_time": "2016-03-15T02:09:39.896+00:00",
	"tracks": [...]
	"type": "audio/mpeg",
	"id": "56e76edfc49c530010f9a2e5",
	"explicit": false,
	"program": {...}
}
```

An episode's program is returned (not shown above) with some details left out. The `shortname` attribute from the show can be used to gather full show.

#### Track
A track looks like this:

```
{
	"artist": "Beirut",
	"log_time": "2016-03-15T02:54:02.016+00:00",
	"mbid": "2984729d-fb43-420b-9d03-d9e34562d843",
	"title": "Elephant Gun",
	"id": "56e77948c49c530020f9a2e6"
}
```

### Using programs
In order to get programs you own you can run the following:

```
curl --header "teal-api-key: thisisakeykeykey" https://api.teal.cool/programs
```

As a result, you will get an array of programs.
One can request a particular program with a request like the following:

```
curl https://api.teal.cool/programs/example-program
```

#### Creating a program
In order to create a program make a HTTP POST request to `/programs` with your program in valid JSON format. A simple example would be:

```
curl --header "teal-api-key: thisisakeykeykey" -X POST -d '{"name":"Example Program"}' https://api.teal.cool/programs
```

When submitted Teal will respond with the created object in JSON and a 200 OK status code. A program will not be created if there is a program with the same shortname already exists (in the example above where a short name is not specified, Teal assumes that the shortname requested is `example-show`. To circumvent this, once can specify a shortname upon creation:

```
curl --header "teal-api-key: thisisakeykeykey" -X POST -d '{"name":"Example Program", "shortname":"greatawesomeshow"}' https://api.teal.cool/programs
```

If created successfully, the response will be 200 OK and the created object.
Once can later view the program by navigating to the program. A program will now be visible to all with the url similar to below:

```
curl https://api.teal.cool/programs/greatawesomeshow
```

#### Updating and deleting a program

Requesting a program using GET, making any changes necessary and making a POST request back to the program URL will be enough to update any program. Deleting is done via a HTTP DELETE request:

```
curl -X DELETE --header "teal-api-key: thisisakeykeykey" https://api.teal.cool/episodes/56e76edfc49c530010f9a2e5
```
A program can not be deleted until every episode that belongs to the program is deleted.

#### Organizations
A program can be a part of none, one or many organizations. A program that is part of a organization is displayed when an organization is queried at `/organizations/<ORGANIZATIONNAME>`:

```
curl https://api.teal.cool/organizations/awesomeorg
```


### Using episodes
Episodes belong to programs. An array of episode IDs can be found in programs. With an episode ID, an episode is located at `/episode/<EPISODEID>`:


```
curl https://api.teal.cool/episodes/56e76edfc49c530010f9a2e5

```

#### Creating an episode
A program to host an episode must exist prior the creation of an episode. An episode can be created in two ways, either to `/programs/<SHORTNAME>/episodes/` or to `/episodes/?shortname=<SHORTNAME>`:

```
curl --header "teal-api-key: thisisakeykeykey" -X POST -d '{"name":"Example Episode"}' https://api.teal.cool/programs/exampleprogram/episodes/
``` 

or


```
curl --header "teal-api-key: thisisakeykeykey" -X POST -d '{"name":"Example tEpisode"}' https://api.teal.cool/episodes/?shortname=exampleprogram
```

#### Updating and deleting a episode
Just like a program deleting is done via a HTTP DELETE request. Requesting an episode using GET, making any changes necessary and making a POST request back to the episode URL will be enough to update any episode:

```
curl --header "teal-api-key: thisisakeykeykey" -X POST -d '{"name":"Updated name of this episode"}' https://api.teal.cool/episodes/56e76edfc49c530010f9a2e5
```

### Using tracks
Tracks belong to episodes and is a part of the standard episode response. Tracks can also be called separately at `/episodes/<EPISODEID>/tracks`:

```
curl https://api.teal.cool/episodes/56e76edfc49c530010f9a2e5/tracks/56e77948c49c530020f9a2e6
```

#### Creating a track
An episode to host a track must exist prior the creation of a track. A track is created by posting to the following: `/episodes/<EPISODEID>/tracks`.

```
curl --header "teal-api-key: thisisakeykeykey" -X POST -d '{ \
	"artist": "Beirut", \
	"mbid": "2984729d-fb43-420b-9d03-d9e34562d843", \
	"title": "Elephant Gun", \ 
}' https://api.teal.cool/programs/exampleprogram/episodes/
``` 

#### Updating and deleting a track
Making a POST request to the track URL at `/episodes/<EPISODEID>/tracks/<TRACKID>` is required update any track. Deleting is done via a HTTP DELETE request:

```
curl -X DELETE --header "teal-api-key: thisisakeykeykey" https://api.teal.cool/episodes/56e76edfc49c530010f9a2e5/tracks/56e77948c49c530020f9a2e6
```

#### MusicBrainz ID in contact of a track
Tracks support an optional attribute `mbid`. This refers to the MusicBrainz Release id. MusicBrainz is a community-maintained open source encyclopedia of music information maintaining a large catalog of music information. An example of a MusicBrainz release is [Andrew Bird's Left Hand Kisses](https://musicbrainz.org/release/9f1caff4-5fd2-4eca-99d9-b7ef4c5b93a5). Including this information as songs are logged might make make future data digging easier.

### Audio Uploads
Audio of an episode can be uploaded to `/episodes/<EPSIODEID>/simpleupload/` as a `application/octet-stream`.

```
curl --data-binary "@/Users/renandincer/Desktop/vbb/vbb59.flac" -H "Content-Type: application/octet-stream" -X POST --header "teal-api-key: thisisakeykeykey" https://api.teal.cool/episodes/56e76edfc49c530010f9a2e5
```

or alternatively, uploads via [Flow](https://github.com/flowjs/flow.js) is supported at 
`/episodes/<EPSIODEID>/upload/`.

All files that can be read by avconv is accepted. This includes a wide array of audio files.

Only one file per episode is allowed. An upload following a successful upload will overwrite the old episode audio.

#### Encoding following an upload
All new uploads are placed on a first come first served queue for encoding. After the encoding process, `audio_url`, `length` and `type` attributes of an episode will be set. There is currently no way to track the progress encoding until it is done. No files are served until the encoding is complete. The only way to track progress of encoding is to look for the changing attributes following the encoding process.

The encoding equivalent to running `avconv -qscale:a 3` which produces an MP3 file with an average bitrate of 175kbps with the bitrate range of 150 to 195kbps.

Original files cannot be downloaded and might be deleted for more space for others. Please store them for your own archival purposes.

### Live Operations
Teal supports metadata on live programs in addition to prerecorded episodes. Teal can capture live audio from a stream, and log tracks live for serving a live audience of listeners.

To serve live listeners, you will need to set up your own stream and online broadcasting infrastructure. Given an online stream, Teal can record, encode and publish the episode.
#### Recording from a stream

To start recording, make a blank POST request to `/episodes/<EPISODEID>/start` which will add a `start_time` attribute to an episode and start recording. To stop recording, perform a POST request to `/episodes/<EPISODEID>/stop` which will add a `end_time` attribute to an episode. 

You will need a valid stream url such as the URL of an Icecast stream defined in the program to record. Teal will return an error if a stream is not defined, if the stream is not reachable, if unable to start recording.

By default, recording start and recording end is delayed by 12 seconds. You can change this with a URL parameter to any other number of seconds below 30 seconds: `/episodes/<EPISODEID>/start?delay=2`. Any number above 30 will be treated as 30. Because of the delay, the request to `/episodes/<EPISODEID>/stop` will respond that many seconds late, when the stopping is actually complete.

#### Live track logging
Independently from the the timestamps or recording of an episode, tracks can be timestamped as well. To log a track, make a GET request to `/episodes/<EPISODEID>/tracks/<TRACKID>/log`. This will place a `log_time` attribute to the track.


#### Querying latest log

Every program has its own latest log event at `/programs/<SHORTNAME>/latest`. In addition, all organizations a program belongs to also gets the latest event at `/organizations/<ORGANIZATIONNAME>/latest`:

```
{
	"type": "episode-start",
	"episode" : {...},
	"program" : {...}
}

```
Episode start and end events contain the same information, the epsiode. The end episode will also have contain updated tracks, if any exist.

```
{
	"type": "episode-end",
	"episode" : {...},
	"program" : {...}
}

```

An example of a track log event - note that both track and episode are included.

```
{
	"type": "track-log",
	"program" : {...},
	"episode" : {...},
	"track" : {
		"artist": "Beirut",
		"log_time": "2016-03-15T02:54:02.016+00:00",
		"mbid": "2984729d-fb43-420b-9d03-d9e34562d843",
		"title": "Elephant Gun",
		"id": "56e77948c49c530020f9a2e6"
	}
}

```

##### Handling timestamps manually
Just like any other field, `start_time`, `end_time` and `log_time` attributes can be set via a JSON HTTP POST request just like when editing the `name` or `description` attributes. However, this method of setting time will not send live events or update the latest logs.

### XML Feed (for iTunes and other podcasting clients)
Teal produces an iTunes compliant XML feed for podcasting. This can be found at `/programs/<SHORTNAME>/feed.xml`:

```
curl https://api.teal.cool/programs/exampleprogram/feed.xml
```

#### Leaving Teal (redirection to an outside feed)
Many podcast clients doesn't let you change feed addresses after creation or they cache it which makes it harder to change hosting providers. Setting the `redirect_url` attribute of a program will redirect every hit to `/programs/<SHORTNAME>/feed.xml`. In addition, using a new feed url xml tag in your new feed will be helpful at making a permanent change:

```
<itunes:new-feed-url>http://newlocation.com/example.rss</itunes:new-feed-url>
``` 

