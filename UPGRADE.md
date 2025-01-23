# Guide for upgrade your flarum container

### Upgrade to latest from v2.0.0

:warning: Backup your database, config.php, composer.lock and assets folder  
:warning: Disable all 3rd party extensions prior to upgrading in panel admin.

1 - Update your docker-compose file, see an example [here](https://github.com/chen00054/flarum/tree/master#2---docker-composeyml)

```yml
version: "3.9"

services:
  flarum:
    image: chen00054/flarum:latest
    ...


```

2 - Pull the last docker images

```sh
docker build -t chen00054/flarum:latest https://github.com/chen00054/flarum.git
docker compose up -d flarum    # The current folder where docker-compose.yml is located
```

3 - Updating your database and removing old assets & extensions

```sh
docker exec -ti flarum php /flarum/app/flarum migrate
docker exec -ti flarum php /flarum/app/flarum cache:clear
```

After that your upgrade is finish. :tada: :tada:


