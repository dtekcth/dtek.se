#!make
include .env
export $(shell sed 's/=.*//' .env)

up-develop:
	# sleep 5 && sudo docker-compose exec web /bin/sh -c "python3 manage.py migrate" &
	docker compose run web /bin/sh -c "python3 manage.py compilemessages -l en"
	docker compose -f docker-compose.yml -f docker-compose.develop.yml up

makemessages:
	docker compose exec web python3 manage.py makemessages -a
	docker compose cp web:/locale .

compilemessages:
	docker compose cp ./locale web:.
	docker compose exec web python3 manage.py compilemessages

build:
	docker compose build

down:
	docker compose down
