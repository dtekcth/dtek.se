FROM python:3.7
ENV PYTHONUNBUFFERED 1

# Installs gettext tools so that localizations stuff works
RUN apt-get update && apt-get install -y gettext libgettextpo-dev

RUN mkdir /code
WORKDIR /code
COPY requirements.txt /code
RUN pip install -r requirements.txt

COPY dtekportal .
COPY locale /locale
COPY scripts /scripts

RUN mkdir /logs

ENV DB_HOST db
ENV DB_PORT 5432
ENV PORT 80
EXPOSE $PORT
CMD /scripts/wait-for-it.sh "$DB_HOST:$DB_PORT" -- \
      uwsgi --http-socket ":$PORT" --module dtekportal.wsgi
