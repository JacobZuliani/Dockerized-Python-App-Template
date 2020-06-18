
# latest version supported by pytype as of 6/18/2020
FROM python:3.6.10-slim-buster

# set timezone to new york time as this will be running un us-east-1
ENV TZ America/New_York

# specify prod or dev, this is overwritten to be dev if the debugger is run in vs-code
ENV RUNTIME_ENV PROD

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE 1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED 1

# prevents exessive debconf complaints: https://github.com/phusion/baseimage-docker/issues/58
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# required to support pytype
RUN apt-get update \
    && apt-get install -y --no-install-recommends apt-utils \
    && apt-get install -y curl \
    && apt-get upgrade \
    && apt-get install -y g++ \
    && apt-get install -y cmake \
    && apt-get install -y bison \
    && apt-get install -y flex \
    && apt-get install -y ninja-build \
    && pip install pip==19.0.1

# Install pip requirements
ADD requirements.txt .
RUN python -m pip install -r requirements.txt

WORKDIR /app
ADD . /app

# Switching to a non-root user
RUN useradd appuser && chown -R appuser /app
USER appuser

# During debugging, this entry point will be overridden
CMD ["python", "src/app.py"]
