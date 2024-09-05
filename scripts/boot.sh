#!/usr/bin/env sh

python3 manage.py migrate
python3 manage.py compilemessages
exec /scripts/wait-for-it.sh db:5432 -- python manage.py runserver 0.0.0.0:8000
