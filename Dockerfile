FROM python:3.7
ENV PYTHONUNBUFFERED 1
RUN mkdir /code
RUN mkdir /static
WORKDIR /code
ADD requirements.txt /code
RUN pip install -r requirements.txt
ADD dtekportal /code/
