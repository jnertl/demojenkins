# Start from the base Ubuntu image
FROM jenkins/jenkins:latest

# Set a working directory inside the container
WORKDIR /app

# Switch to root to install packages
USER root
RUN apt-get update \
	&& apt-get install -y git python3 python3-pip python3-venv \
	&& rm -rf /var/lib/apt/lists/*

# Switch back to jenkins user
USER jenkins

COPY ./requirements.txt /app/requirements.txt
RUN python3 -m venv venv
RUN ./venv/bin/pip3 install --no-cache-dir -r requirements.txt
