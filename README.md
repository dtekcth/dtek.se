# Dtek portal

The DTEK portal. Originally written by Chalmers IT, then Viktor downloaded the
HTML and changed the colors, turning it into a simple static web page. However,
maintaining it became difficult, especially when an English version was
introduced, which was accomplished by copying the Swedish html file and changing
all the Swedish strings into English. Therefore, BS decided to rewrite the thing
in Django.

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
