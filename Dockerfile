# Lightweight image for docker
FROM python:3.9-alpine3.13 
LABEL maintainer="Kyle Zunino"

# Tells python not to  buffer output. Prints python messages to the console and screen
ENV PYTHONUNBUFFERED 1

# Copy requiremtns from local machine to docker image
COPY ./requirements.txt /tmp/requirements.txt
# Dev Dependencies
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
# Copy app directory to /app inside container
COPY ./app /app
# Default dir that commands are run from which is /app in container
WORKDIR /app
# Expose 8000 from container to the machine
EXPOSE 8000

# Sets dev env to false but we overwrite this in docker-compose file to true
ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV  PATH="/py/bin:$PATH"

# Switches to a non-root user with full privilges 
USER django-user