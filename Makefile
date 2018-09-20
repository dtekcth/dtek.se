up-prod:
	sudo docker-compose run web python3 manage.py migrate
	sudo docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
	sudo docker-compose exec web /bin/sh -c "python3 manage.py collectstatic --noinput"

up-develop:
	sudo docker-compose run web python3 manage.py migrate
	sudo docker-compose -f docker-compose.yml -f docker-compose.develop.yml up

down:
	sudo docker-compose down
