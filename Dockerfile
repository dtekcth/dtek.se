FROM python:3.7-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
WORKDIR /code

# Installs gettext tools so that localizations stuff works
RUN apt-get update && apt-get install -y build-essential gettext libgettextpo-dev

COPY requirements.txt ./
RUN pip install -r requirements.txt

COPY dtekportal .
COPY locale /locale

RUN mkdir /logs

EXPOSE 80

CMD ["uwsgi", "--socket", "0.0.0.0:3000", \
      "--protocol", "uwsgi", \
      "--module", "dtekportal.wsgi"]

#CMD /scripts/wait-for-it.sh "$DB_HOST:$DB_PORT" -- \
#      uwsgi --http-socket ":$PORT" --module dtekportal.wsgi
