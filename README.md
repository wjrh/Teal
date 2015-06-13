![](http://wjrh.org/teal-logo.png)

Teal is [WJRH](http://wjrh.org)'s DJ-Show-Episode management app, complementing other services, like recording, automation etc.
Teal also provides an API endpoint for mobile applications and external data consumption.

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
| Method | URL | Description | Required JSON parameters |
|--------|------------|-----------------|--------------------------|
| GET | /shows | lists all shows |  |
| POST | /shows | add a new show | at least 1 DJ id |
| GET | /shows/:id | get detail info about show |  |
| PUT | /shows/:id | update a show |  |
| DELETE | /shows/:id | delete a show |  |

### DJs
| GET | /djs | list all djs |  |
| POST | /djs | add a new dj |  |
| GET | /djs/:id | get detail info about dj |  |
| PUT | /shows/:id | update a dj |  |
| DELETE | /shows/:id | delete a dj |  |

### Episodes
| GET | /shows/:id/episodes | list all episodes of a show |  |
| POST | /shows/:id/episodes | create a new episode |  |
| GET | /episodes/:id | get details about an episode |  |
| PUT | /episodes/:id | update an episode |  |
| DELETE | /episodes/:id | delete an episode |  |

