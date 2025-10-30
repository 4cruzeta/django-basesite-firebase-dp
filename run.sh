#!/bin/sh

# Exit immediately if a command exits with a non-zero status.
set -e

# Change to the directory containing manage.py
cd basesite

# Run the Django migrations
python manage.py migrate --noinput

# Start the Gunicorn server
# We now refer to config.wsgi because we are inside the 'basesite' directory
gunicorn --bind :8080 --workers 2 config.wsgi