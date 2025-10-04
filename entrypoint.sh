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

# Check if a superuser exists; if not, one will be created.
echo "Checking for existing superuser..."
if [ "$DJANGO_SUPERUSER_USERNAME" ] && [ "$DJANGO_SUPERUSER_PASSWORD" ]; then
  DJANGO_SETTINGS_MODULE=truck_signs_designs.settings.test_docker python -c "
import django;
django.setup();
from django.contrib.auth import get_user_model;
User = get_user_model();
username = '$DJANGO_SUPERUSER_USERNAME';
email = '$DJANGO_SUPERUSER_EMAIL';
password = '$DJANGO_SUPERUSER_PASSWORD';
if not User.objects.filter(username=username).exists():
    User.objects.create_superuser(username, email, password);
    print('Superuser created.');
else:
    print('Superuser already exists.');
"
fi

gunicorn truck_signs_designs.wsgi:application --bind 0.0.0.0:8000



echo "Postgresql migrations finished"

#python manage.py runserver #for testing