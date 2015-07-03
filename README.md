![](http://wjrh.org/teal-logo.png)

Teal is [WJRH](http://wjrh.org)'s creator-Program-Episode management service.

## Getting Started
1.  Install Ruby [here](https://www.ruby-lang.org/en/documentation/installation/)
2. Install Bundler if you haven't yet.

        gem install bundler

3. Install dependencies using Bundler

        bundle install

4. Run Teal on your local machine
 
        foreman start

5. Visit Teal at [localhost:9000](http://localhost:9000)

## Usage

### Creators
Creators represent past and present people contritbuing to the station.

Add a creator by sending a POST request with the creator data to `/creators`:

    {
      "lafayetteid": "renand",
      "email": "renand@lafayette.edu",
      "name": "DJ RENren",
      "real_name": "Renan Dincer",
      "description": "Whatever I want to put here",
      "image_url": "http://wjrh.org/image.png"
    }

on successful request, this will return all the information along with a unique id

    {
      "id": 1,
      "lafayetteid": "renand",
      "email": "renand@lafayette.edu",
      "name": "DJ RENren",
      "real_name": "Renan Dincer",
      "description": "Whatever I want to put here",
      "created_at": "2015-07-03T01:56:17.160Z",
      "updated_at": "2015-07-03T01:56:17.160Z",
      "image_url": "http://wjrh.org/image.png"
    }

you can view all creators by sending a GET request to `/creators` 

    [
      {
        "id": 1,
        "name": "DJ RENren",
        "image_url": "http://wjrh.org/image.png"
      },
      {
        "id": 2,
        "name": "Hopeless Women",
        "image_url": "http://wjrh.org/women.png"
      },
      {
        "id": 3,
        "name": "Flying Elephant",
        "image_url": "http://wjrh.org/elephant.png"
      }
    ]

sending a GET request to `/creators/1` will return more detailed information about the creator with the id 1

    {
      "id": 1,
      "name": "DJ RENren",
      "description": "Whatever I want to put here",
      "programs": [
        {
          "id": 1,
          "title": "Super Awesome Shhow"
        },
        {
          "id": 2,
          "title": "Other Awesome Program"
        }
      ]
    }

a creator can be updated with a PUT request to `/creators/:id` and can be deleted with a DELETE request to the same URL

### Programs
Programs represent a recurring time block in the radio. Programs have creators that are responsible of creating, editing and deleting contents of the program. Programs are blueprints for episodes.

### Episodes
Episodes are instances of programs that have a start wh

### Logging a song

## API Reference
| Method | URL | Description | Notes |
|--------|------------|-----------------|--------------------------|
| GET | /creators | list all creators |  |
| POST | /creators | add a new creator |  |
| GET | /creators/:id | get detail info about creator |  |
| PUT | /creators/:id | update a creator |  |
| DELETE | /creators/:id | delete a creator |  |
| GET | /programs | lists all programs |  |
| POST | /programs | add a new program | at least 1 creator id required |
| GET | /programs/:id | get detail info about program |  |
| PUT | /programs/:id | update a program |  |
| DELETE | /programs/:id | delete a program |  |
| GET | /programs/:id/episodes | list all episodes of a program |  |
| POST | /programs/:id/episodes | create a new episode |  |
| GET | /episodes/:id | get details about an episode |  |
| PUT | /episodes/:id | update an episode |  |
| DELETE | /episodes/:id | delete an episode |  |
| POST | /episodes/:id/songs |  |  |
| PUT | /episodes/:id/songs/:log_id |  |  |
| DELETE | /episodes/:id/songs/:log_id |  |  |

#TODO

- episode start stop times
- episode lifecycle, creation and date time etc.
- active/non-active creators
- being able to assign times to programs
- concept of seasons?
