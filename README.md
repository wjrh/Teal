![](http://wjrh.org/teal-logo.png)

Teal is [WJRH](http://wjrh.org)'s DJ-Show-Episode management service.

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
You can hit the links

| Method | URL | Description | Notes |
|--------|------------|-----------------|--------------------------|
| GET | /shows | lists all shows |  |
| POST | /shows | add a new show | at least 1 DJ id required |
| GET | /shows/:id | get detail info about show |  |
| PUT | /shows/:id | update a show |  |
| DELETE | /shows/:id | delete a show |  |

### DJs
| Method | URL | Description | Notes |
|--------|------------|-----------------|--------------------------|
| GET | /djs | list all djs |  |
| POST | /djs | add a new dj |  |
| GET | /djs/:id | get detail info about dj |  |
| PUT | /shows/:id | update a dj |  |
| DELETE | /shows/:id | delete a dj |  |

### Episodes
| Method | URL | Description | Notes |
|--------|------------|-----------------|--------------------------|
| GET | /shows/:id/episodes | list all episodes of a show |  |
| POST | /shows/:id/episodes | create a new episode |  |
| GET | /episodes/:id | get details about an episode |  |
| PUT | /episodes/:id | update an episode |  |
| DELETE | /episodes/:id | delete an episode |  |

### Airings
Airings are instances of when an episode airs on the radio stream.
| Method | URL | Description | Notes |
|--------|------------|-----------------|--------------------------|
| POST | /episodes/:id/airings | create a new airing |  |
| PUT | /airings/:id | update an airing |  |
| DELETE | /airings/:id | delete an airing |  |

### Songs
| Method | URL | Description | Notes |
|--------|------------|-----------------|--------------------------|
| POST | /episodes/:id/songs | log a new song |  |
| DELETE | /episodes/:id/songs/:log_id  | delete a song |  |

