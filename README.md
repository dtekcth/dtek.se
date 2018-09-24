# Dtek portal

The DTEK portal. Originally written by Chalmers IT, then Viktor downloaded the
HTML and changed the colors, turning it into a simple static web page. However,
maintaining it became difficult, especially when an English version was
introduced, which was accomplished by copying the Swedish html file and changing
all the Swedish strings into English. Therefore, BS decided to rewrite the thing
in Django.

## Nginx setup

Here's what you need to set up in nginx to get the site running:

First of all, you must define the port or socket that django uses. Replace 8000
below with the port that your docker image exposes.

```
upstream django {
    server localhost:8000;
}

```

The location `/` should uswgi pass to django, and `/static/` should be an alias
to the `static` directory in the dtek portal directory.

```

server {
    listen 80;
    listen [::]:80;
    server_name dtek.se www.dtek.se local.dtek.se sagge.dtek.se;

    location / {
        uwsgi_pass django;
        include /etc/nginx/uwsgi_params;
    }

    location /static/ {
        alias /path/to/dtek/portal/static/;
    }
}
```

Note that each `server_name` must also be added to `ALLOWED_HOSTS` in
`settings.py`.

## Starting the site

Before starting the site, you must add a few secrets to the project directory
that are not checked in to Git:

* In the `dtekportal` directory, create a file called `secret-key.txt`. In this
    file you must place a secret key for django. Just google "Django Secret Key
    Generator" or something like that and you will find it. Just paste the plain
    text without any quotes or newlines into `secret-key.txt`.

Once this is done and nginx is set up properly, it should be possible to start the site. First of
all, you need to build the container using `make build`.

To start the site in a development environment, (meaning DEBUG is set to TRUE in
django among other things) run `make up-develop` and the site should be
accessible at `localhost:8000` or whatever port your docker container exposes.
If django complains about having unapplied migrations, you might have to run
`(sudo) docker-compose run web python3 manage.py migrate`, then restart the
container by running `make down` followed by `make up-develop`.

To start the site in a production environment, instead run `make up-prod` after
building the container. The site should now be accessible at the domains
specified in `server_name` in the nginx config (provided that the domains in
question are pointed at the correct IP). If you want to try running the
production environment locally without pointing a domain to your IP, you can
just add that domain to your `host` file (Google is your friend).


## TODO in documentation

* Describe how to start the thing, i.e. you need the secret key and db
    password as txt files + how to start docker container
* Describe what has to be set up in nginx
* Explain how translations work
* Describe page structure, i.e. where to find different parts of the page, what
    goes in the site global stuff vs what goes in the homepage app.
* Describe how to use a static page as a view vs a normal view
* Describe what hacks are being used and why, i.e. the multi line tag hack and
    the django-macro package
* Describe things that could be changed, i.e. IT's site was written with LESS,
    our version just uses their compiled CSS (with some modifications), so it's
    a mess. If someone wants to rewrite the thing in LESS that would be great!

## TODO in code
* Add database password!
* Put database data in volume so that it gets preserved
* Maybe add option to parametrize port?
    - Idea: put password and port in env-file (docker-compose thing), which can
        be updated without messing with docker-compose files
