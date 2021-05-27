# Check https://github.com/daavelino/vulnerability-catalog/wiki/Using-Docker-to-run-Catalog

# Use an official Python 3 runtime as a parent image
FROM python:3.6

# Set apps home directory:
WORKDIR .

# Adds the application code to the image:
ADD . ${APP_DIR}

# Build the project structure without Python's Virtual Environment
RUN apt-get update && apt-get install -y libxml2-dev libxmlsec1-dev
RUN python setup.py build-novenv

# Setup Admin user. Change it properly:
ENV DJANGO_SU_NAME=admin
ENV DJANGO_SU_EMAIL=admin@example.com
ENV DJANGO_SU_PASSWORD=vcatalog

# Server variables
ENV HOSTNAME=localhost
ENV PORT=8000

RUN echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('${DJANGO_SU_NAME}', '${DJANGO_SU_EMAIL}', '${DJANGO_SU_PASSWORD}')" | python base/manage.py shell

# Make port 8000 available to the world outside this container:
EXPOSE 8000

# Lauch Catalog. Make sure to set IP address and port properly:
WORKDIR base
CMD ["./run.sh","${HOSTNAME}:${PORT}"]
