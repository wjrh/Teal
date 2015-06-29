![](http://wjrh.org/teal-logo.png)

Teal is [WJRH](http://wjrh.org)'s creator-Show-Episode management service.

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

### Shows
Shows represent a recurring time block in the radio. Shows have creators that are responsible of creating, editing and deleting contents of the show. Shows are blueprints for episodes.

#### Creating a new show
| GET | /shows | lists all shows |  |
| POST | /shows | add a new show | at least 1 creator id required |
| GET | /shows/:id | get detail info about show |  |
| PUT | /shows/:id | update a show |  |
| DELETE | /shows/:id | delete a show |  |

### creators
creators represent past and present creators at the radio station.

| Method | URL | Description | Notes |
|--------|------------|-----------------|--------------------------|
| GET | /creators | list all creators |  |
| POST | /creators | add a new creator |  |
| GET | /creators/:id | get detail info about creator |  |
| PUT | /creators/:id | update a creator |  |
| DELETE | /creators/:id | delete a creator |  |

### Episodes
Episodes are instances of shows that have a start wh

| Method | URL | Description | Notes |
|--------|------------|-----------------|--------------------------|
| GET | /shows/:id/episodes | list all episodes of a show |  |
| POST | /shows/:id/episodes | create a new episode |  |
| GET | /episodes/:id | get details about an episode |  |
| PUT | /episodes/:id | update an episode |  |
| DELETE | /episodes/:id | delete an episode |  |

### Logging a song
POST /episodes/:id/songs
DELETE /episodes/:id/songs/:log_id


#TODO

- episode start stop times
- episode lifecycle, creation and date time etc.
- active/non-active creators
- being able to assign times to shows
- concept of seasons?
