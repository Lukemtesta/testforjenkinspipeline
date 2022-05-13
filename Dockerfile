# syntax=docker/dockerfile:1
FROM python:3.8
ENV PYTHONDONTWRITEBYTECODE=1
WORKDIR /code
COPY requirements.txt /code/
RUN pip install -r requirements.txt
# COPY /from/path /to/path will compress the folder into a tar and send it with the docker context during the 
# build stage. This means any changes to this directory will not be discovered


