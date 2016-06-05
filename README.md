# Teal

Teal is a audio and feed host with a program-episode relationship. It automatically produces an iTunes feed for podcasting and logs tracks played for radio shows. It allows direct uploads or broadcast stream capture for your content.

Teal is composed of several Docker containers, managed with Docker Compose:

![Teal Setup](http://i.imgur.com/DHoo1Yk.png)

### Simple deployment (using docker-compose)

1. put https certificates on the host machine at `/var/lib/acme/` (refer to acme docs [here](https://hlandau.github.io/acme/userguide))
2. enter https certificate location and change server name on `config/nginx-prod.conf` (basically change whereever it says `api.teal.cool` and `teal.cool` to your values)
3. enter details at `config/teal.yml` (see example at `config/teal.yml.example`)
4. start local docker deamon (or connect to remote deamon by setting DOCKER_TLS_VERIFY, DOCKER_HOST, DOCKER_CERT_PATH on your local machine - can be easily with docker-machine)
5. `docker-compose up -d`

### Pushing changes to individual containers in production

It is useful to push an update to the production but this should be done without stopping stateful containers such as the `encode_worker` or `recorder` so that ongoing recordings or encodings don't get cut in half. The following will rebuild only the containers and restart the containers only if there is a change.

Teal: `docker-compose build teal && docker-compose up -d --no-deps teal`

Frontend: `docker-compose build nginx && docker-compose up -d --no-deps nginx`