FROM python:3.7
ENV PYTHONUNBUFFERED 1

# Installs gettext tools so that localizations stuff works
RUN apt-get update && apt-get install -y gettext libgettextpo-dev

RUN mkdir /code
RUN mkdir /static
RUN mkdir /locale
RUN mkdir /logs
RUN mkdir /scripts

WORKDIR /code
ADD requirements.txt /code
RUN pip install -r requirements.txt
ADD dtekportal /code/
