Table of Contents
=================

   * [Dtek portal](#dtek-portal)
   * [Setup](#setup)
      * [Nginx setup](#nginx-setup)
      * [Starting the site](#starting-the-site)
      * [Creating a superuser](#creating-a-superuser)
   * [How the site works](#how-the-site-works)
      * [Page structure](#page-structure)
         * [Global](#global)
         * [Homepage app](#homepage-app)
         * [URL](#url)
      * [Creating a static page](#creating-a-static-page)
      * [Creating links to internal urls](#creating-links-to-internal-urls)
      * [Translations](#translations)

# Dtek portal

The DTEK portal. Originally written by Chalmers IT, then Viktor downloaded the
HTML and changed the colors, turning it into a simple static web page. However,
maintaining it became difficult, especially when an English version was
introduced, which was accomplished by copying the Swedish html file and
changing all the Swedish strings into English. Therefore, BS decided to rewrite
the thing in Django.

# Setup

## Nginx setup

The service can either be run as a self-contained service as exemplified by the
compose file or hosted by an external nginx instance. Refer to site.conf for an
example of an nginx server configuration.

Note that each `server_name` must also be added to `ALLOWED_HOSTS` in
`settings.py`.

## Starting the site

Before starting the site, you must add a few variables to the project directory
that are not checked in to Git:

* Django's secret key
* Database password

There is a file in the root directory of this repo called `.env.template`.
This file should be copied into a file called `.env`, where you define these
variables according to your liking. Django's secret key should be a "large,
unpredictable value". Just google "[Django Secret Key
Generator](https://www.miniwebtool.com/django-secret-key-generator/)" and you
should find something.

Once this is done, it should be possible to start the site. First of all, you
need to build the container using `make build`.

To start the site in a development environment, run `make up-develop` and the
site should be accessible at `localhost:8000`. If django complains about having
unapplied migrations, you might have to run `docker compose run web python3
manage.py migrate`, then restart the container by running `make down` followed
by `make up-develop`.

## Creating a superuser

If you're starting the site for the first time, it's probably a good idea to
create a superuser for the admin interface. (For now, the site is just static
content, meaning the admin interface is unused and creating a superuser might
not be necessary. It feels like it might be a good idea to do it anyway,
though). To do this, start up the container and run `docker compose exec web
/bin/sh -c "python3 manage.py createsuperuser`.

# How the site works

An individual who wishes to edit this website should possess some rudimentary
knowledge of Django. Such a person ought to visit the [Django
Documentation](https://docs.djangoproject.com/), whence answers to all Django
related inquiries are given. However, this section of the documentation will
give an introduction to some key aspects of Django that will be useful when
editing this particular site:

## Page structure

Django insists on putting stuff in what it calls *apps* -- semi-independent
units that together form a whole website. In a website consisting mostly of
static content, it is not always clear what should be put in an app and what
should be declared globally for the whole project, but this is how I've done it
for the dtek portal:

### Global

Any content that is shared across **every** page of the site (such as the top
banner and footer, as well as the `404.html` page (although I'm not entirely
sure about that one...)) is put as global content on the website, i.e. in
`dtekportal/templates/` for templates and `dtekportal/staticfiles/`  for static
files such as css or javascript.

### Homepage app

Content that is specific to certain pages, such as the index page or the
newsletter page, are placed inside the `homepage` app, i.e. inside
`dtekportal/homepage/templates` or `dtekportal/homepage/static/`.

If some dynamic feature is added in the future, such as a "committee pages"
feature, this should be put in a new app.

### URL

Explaining how URLs work in Django is beyond the scope of this documentation,
but it should be mentioned that url patterns are defined in a file called
`urls.py`. There is one `urls.py` for the whole project as well as one for each
app.

Usually, the global url config just delegates urls to the apps, such as
pointing `www.website.com/blog/*` to the blog app and `www.website.com/admin/*`
to the admin app.  On the dtek portal, the root url `dtek.se/*` is delegated by
the global url config to the `homepage` app url config. Thus, if a new static
page is added to the homepage app, the url for that page should be defined in
`dtekportal/homepage/urls.py`.

## Creating a static page

The "normal" way to create a page in Django is to first create a template in
`myapp/templates` and then defining a view in `views.py` which fetches data
from the database and injects it into said template.  Finally, `myapp/urls.py`
is used to point a url to that page.

If you just want to create a static page that doesn't require datbase data to
be fetched, it's a bit superfluous to create a view. Instead, there's a quick
way to use the template as a static view directly: In `myapp/urls.py`, to add
the template `test.html` as a view, do as follows:

```python
...
from django.views.generic import TemplateView

urlpatterns = [
    path("testurl", TemplateView.as_view(template_name='myapp/test.html'), name='test'),
]
```

## Creating links to internal urls

If you want to create a link to another page on the website, DON'T hardcode the
url!  Instead, use django's url functions. For instance, to link to the index
page in a template:

```python
{% load static %}

.
.
.

<a href="{% url 'homepage:index' %}"> Home </a>
```

where `homepage` is the namespace of your app, and `index` is the `name`
parameter in the url as defined in `urls.py`.

## Translations

The website is written with Swedish as its original language. In order to make
a string translatable,  it must be wrapped in a function. For details on how to
do this in pyton code and template code respectively, see the [Django docs on
translation](https://docs.djangoproject.com/en/2.1/topics/i18n/translation/).

The mapping from Swedish to English lives in `locale/en/LC_MESSAGES/django.po`.
When you have edited a file and added strings that need to be created, run
`make makemessages`. This will update the .po file to contain the new strings,
whose translations can now be filled in. Any translation strings that have been
marked as "fuzzy" will be ignored by Django, so make sure to clean those up
before finishing.

For the website to update, you need to compile the .po file. This can be done
by running `make compilemessages`. If this does not work, try stopping the
container using `make down` and starting it up again; the makefile is
configured to compile the messages as the container starts.
