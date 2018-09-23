up-prod:
	sudo docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
	sudo docker-compose exec web /bin/sh -c "python3 manage.py migrate"
	sudo docker-compose exec web /bin/sh -c "python3 manage.py compilemessages -l en"
	sudo docker-compose exec web /bin/sh -c "python3 manage.py collectstatic --noinput"

up-develop:
	# sleep 5 && sudo docker-compose exec web /bin/sh -c "python3 manage.py migrate" &
	sudo docker-compose run web /bin/sh -c "python3 manage.py compilemessages -l en"
	sudo docker-compose -f docker-compose.yml -f docker-compose.develop.yml up

makemessages:
	sudo docker-compose run web python3 manage.py makemessages -l en

compilemessages:
	sudo docker-compose exec web python3 manage.py compilemessages -l en


build:
	sudo docker-compose build

down:
	sudo docker-compose down
