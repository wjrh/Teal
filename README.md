![](http://wjrh.org/teal-logo.png)

Teal is [WJRH](http://wjrh.org)'s program-episode management system.

#### Listing Programs
```
curl https://teal.cool/programs/
```

```
[
	{
    "categories": [
      "Talk",
      "Sports"
    ],
    "creators": [
      "Ryan Callanan",
      "Ari Kaufman",
      "Mitch Leeds"
    ],
    "name": "Southpaw Sports Talk",
    "shortname": "southpaw-sports-talk"
	},
  {
    "categories": [
      "Talk",
      "Podcast"
    ],
    "creators": [
      "B.R. Cohen",
      "Simon Tonev"
    ],
    "description": "Simon Tonev and B.R. Cohen talk to each other and humans about important things, solving problems, taking quizzes, learning lessons on Lafayette College's WJRH. Renan Dincer is our intrepid producer, Michelle Polton-Simon is our intern. Follow us [@somelaterdate](https:\/\/twitter.com\/somelaterdate).",
    "image": "http:\/\/media.wjrh.org\/vbb\/logo2.jpg",
    "name": "Various Breads and Butters",
    "shortname": "vbb",
    "subtitle": "B.R. Cohen and Simon Tonev talk to each other and others"
  }
]
```

#### Getting details about a show

```
curl https://teal.cool/programs/vbb
```

```
{
  "categories": [
    "Talk",
    "Podcast"
  ],
  "copyright": "WJRH - Creative Commons Attribution-ShareAlike 4.0 International",
  "created_at": "2015-10-23T05:47:12.512Z",
  "creators": [
    "B.R. Cohen",
    "Simon Tonev"
  ],
  "description": "Simon Tonev and B.R. Cohen talk to each other and humans about important things, solving problems, taking quizzes, learning lessons on Lafayette College's WJRH. Renan Dincer is our intrepid producer, Michelle Polton-Simon is our intern. Follow us [@somelaterdate](https:\/\/twitter.com\/somelaterdate).",
  "id":
  "image": "http:\/\/media.wjrh.org\/vbb\/logo2.jpg",
  "name": "Various Breads and Butters",
  "shortname": "vbb",
  "subtitle": "B.R. Cohen and Simon Tonev talk to each other and others",
  "updated_at": "2015-12-27T13:39:56.648Z",
  "episodes": [
    {
      "created_at": "2015-10-23T05:50:40.713Z",
      "description": "We're solving problems. Small talk, ice cream flavors, fund drives, professors' tests, fixing stuff in post, you name it",
      "guid": "wjrh.org\/episodes\/1",
      "id": "5629cab05853e905c7000004",
      "image": "http:\/\/media.wjrh.org\/vbb\/logo2.jpg",
      "medias": [
        {
          "created_at": "2015-10-23T05:50:40.714Z",
          "id": "5629cab05853e905c7000005",
          "length": "30:29",
          "type": "audio\/mpeg",
          "updated_at": "2015-10-23T05:50:40.716Z",
          "url": "http:\/\/media.wjrh.org\/vbb\/vbb43.mp3"
        }
      ],
      "name": "43: All Icing No Cake",
      "pubdate": "2015-06-01T19:00:00.000Z",
      "updated_at": "2015-10-23T05:50:40.716Z"
    },
		{...}
	]
}
```
