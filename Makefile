#!make
include .env
export $(shell sed 's/=.*//' .env)

test:
	env

# delete this
up-prod:
	sudo -E docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
	sudo -E docker-compose exec web /bin/sh -c "python3 manage.py migrate"
	sudo -E docker-compose exec web /bin/sh -c "python3 manage.py compilemessages -l en"
	sudo -E docker-compose exec web /bin/sh -c "python3 manage.py collectstatic --noinput"

# delete this too
up-develop:
	# sleep 5 && sudo docker-compose exec web /bin/sh -c "python3 manage.py migrate" &
	sudo -E docker-compose run web /bin/sh -c "python3 manage.py compilemessages -l en"
	sudo -E docker-compose -f docker-compose.yml -f docker-compose.develop.yml up

makemessages:
	sudo -E docker compose exec web python3 manage.py makemessages -a
	sudo -E docker compose cp web:/locale .

compilemessages:
	sudo -E docker compose cp ./locale web:.
	sudo -E docker compose exec web python3 manage.py compilemessages

build:
	sudo -E docker-compose build

down:
	sudo -E docker-compose down
