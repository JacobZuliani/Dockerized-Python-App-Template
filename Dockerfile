# For more information, please refer to https://aka.ms/vscode-docker-python
FROM python:3.8-slim-buster

# set timezone to new york time as this will be running un us-east-1
ENV TZ America/New_York

# specify prod or dev, this is overwritten to be dev if the debugger is run in vs-code
ENV RUNTIME_ENV PROD

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE 1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED 1

# Install pip requirements
ADD requirements.txt .
RUN python -m pip install -r requirements.txt

WORKDIR /app
ADD . /app

# Switching to a non-root user, please refer to https://aka.ms/vscode-docker-python-user-rights
RUN useradd appuser && chown -R appuser /app
USER appuser

# During debugging, this entry point will be overridden. For more information, please refer to https://aka.ms/vscode-docker-python-debug
CMD ["python", "src/app.py"]
