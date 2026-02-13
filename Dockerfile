FROM python:3.7-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
WORKDIR /code

# Installs gettext tools so that localizations stuff works
RUN apt-get update && apt-get install -y build-essential gettext libgettextpo-dev postgresql libpq-dev

COPY requirements.txt ./
RUN pip install -r requirements.txt

COPY dtekportal .
COPY locale /locale

RUN mkdir /logs

# Default values to match previous hardcoded values
ENV DJANGO_ALLOWED_HOSTS="dtek.se,www.dtek.se"
ENV DB_NAME="dtekportal"
ENV DB_USER="postgres"
ENV DB_HOST="db"
ENV DB_PORT="5432"

EXPOSE 80

CMD rm -r /staticfiles/* && python3 manage.py migrate && python3 manage.py compilemessages && cp -r /code/staticfiles/* /staticfiles/. && uwsgi --socket 0.0.0.0:3000 --protocol uwsgi --module dtekportal.wsgi

#CMD /scripts/wait-for-it.sh "$DB_HOST:$DB_PORT" -- \
#      uwsgi --http-socket ":$PORT" --module dtekportal.wsgi
