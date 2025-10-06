#!/usr/bin/env bash
set -e

echo "Waiting for postgres to connect ..."

while ! nc -z db-truck 5432; do
  sleep 0.1
done

echo "PostgreSQL is active"

python manage.py collectstatic --noinput
python manage.py migrate
python manage.py makemigrations

#Check if a superuser exists; if not, one will be created.
echo "Checking for existing superuser..."
if [ "$DJANGO_SUPERUSER_USERNAME" ] && [ "$DJANGO_SUPERUSER_PASSWORD" ]; then
  python manage.py shell << EOF
from django.contrib.auth import get_user_model
User = get_user_model()
if not User.objects.filter(username="$DJANGO_SUPERUSER_USERNAME").exists():
    User.objects.create_superuser(
        "$DJANGO_SUPERUSER_USERNAME",
        "$DJANGO_SUPERUSER_EMAIL",
        "$DJANGO_SUPERUSER_PASSWORD"
    )
    print("Superuser created.")
else:
    print("Superuser already exists.")
EOF
fi

echo "Postgresql migrations finished"

if [ "$DEBUG" = "true" ]; then
  echo "DEBUG mode active – starting Django development server"
  python manage.py runserver 0.0.0.0:8000
else
  echo "Production mode – starting Gunicorn"
  gunicorn truck_signs_designs.wsgi:application --bind 0.0.0.0:8000
fi