# Dockerized-Python-App-Template

This reposiory contains a template for quickly developing deployment ready Python applications:

- In a Docker Container
- With AWS CloudWatch for logging
- Using Microsoft VS-Code
- Using the debugpy debugger

#### Debugging in docker containers (differences between DEV and PROD):

My goal with this template was to make my production environment both extremely minimal and extremely similar to my dev environment. This means I won't do something like run a vs-code remote development server in my container. The template has one dockerfile specifying the minimal prod environment (no debugger installed in prod).

Everything specific to the development environment is applied by the launch configuration that's run when the debugger is run. Here is everything dev does differently from prod:
- mounts updated project code to the docker container so it does not need to be rebuilt
- installs debugpy (if not already installed)
- opens port 5678 into the docker container so vs-code can talk to the debugging server
- runs the debugging server in the docker container and connects to the server
- mounts ~/.aws to the container so boto3 applications can authenticate themselves
- overwrites the container environment variable 'RUNTIME_ENV' from 'PROD' to 'DEV', this tells the logger not to send logs to cloudwatch

The vs-code tasks triggered by the launch config put all of this into a docker run command.

#### CloudWatch Logging:

In production, apps I make with this template send me an email (triggered by a cloudwatch alarm) whenever an an exception occours that affects a users product experience. In development, if I run the same app a different log handler is used sending the logs to stdout instead of cloudwatch. The logging system knows if it is being run in production using an environment variable in the container, this environment variable is overwritten when the debugger is run.

Logging is done using the Python logging module with a custom log handler called [watchtower](https://github.com/kislyuk/watchtower).

#### AWS Authentication in PROD and DEV:

In production dockerized apps using boto3 running on EC2 instances will try to contact the EC2 metadata service for authentication and can do so from inside a docker container. This means that its possible to authenticate a production app using an IAM policy applied to the service instead of putting sensitive cridentials in a text file.

In development there is no metadata service to contact. Instead I mount the cridentials used by the AWS CLI (stored in ~/.aws) to the docker container as a volume when the debugger is run. Boto3 will automatically look for cridentials stored there. Encrypt your hard drive to keep these somewhat safe!

