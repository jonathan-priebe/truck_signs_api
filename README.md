<div align="center">

![Truck Signs](./screenshots/Truck_Signs_logo.png)

# Signs for Trucks

![Python version](https://img.shields.io/badge/Python-3.8.10-4c566a?logo=python&logoColor=white&colorB=pink&style=flat-square&colorA=4c566a)
![Django version](https://img.shields.io/badge/Django-2.2.8-4c566a?logo=django&logoColor=white&colorB=pink&style=flat-square&colorA=4c566a)
![Django-RestFramework](https://img.shields.io/badge/Django_Rest_Framework-3.12.4-red.svg?logo=django&logoColor=white&colorA=4c566a&colorB=pink&style=flat-square)

</div>

---

## Project Handover  

📄 [Truck Signs API Checkliste PDF](<./Truck Signs API Checkliste.pdf>)

---

## 📚 Table of Contents

- [🛒 Description](#-description)
  - [⚙️ Settings](#️-settings)
  - [🧩 Models Overview](#-models-overview)
  - [🔍 Views](#-views)
- [🚀 Quickstart](#-quickstart)
  - [🛠️ Preparing the Docker Image](#️-preparing-the-docker-image)
  - [🐳 How to Build the Docker Image](#-how-to-build-the-docker-image)
  - [⚙️ Setup the Rest](#️-setup-the-rest)
- [🚦 Usage](#-usage)
- [🖼️ Screenshots](#️-screenshots)
  - [📱 Mobile View](#-mobile-view)
  - [💻 Desktop View](#-desktop-view)
- [🔗 Useful Links](#-useful-links)

---

## 🛒 Description

**Signs for Trucks** is an online store for pre-designed vinyls with customizable lettering. Clients can upload their own designs or choose from categories like:

- Truck logos with lettering
- Fire extinguisher vinyls
- Unit number vinyls
- Simple lettering without logos

### ⚙️ Settings

The `settings` folder inside `truck_signs_designs` contains environment-specific configurations:

- `base.py`: shared settings
- `development.py`, `docker.py`, `production.py`: environment overrides
- `.env`: sensitive variables (e.g. DB credentials, Stripe keys)

To switch environments, modify `__init__.py`.

### 🧩 Models Overview

- **Category**: Defines vinyl types (e.g. Truck Logo, Fire Extinguisher)
- **Lettering Item Category**: Defines pricing categories (e.g. Company Name, VIN)
- **Lettering Item Variations**: Stores client-entered text
- **Product Variation**: Combines base product + client lettering
- **Order**: Stores cart, contact, and shipping info
- **Payment**: Stripe-based payment metadata

Stripe is used for payment processing: [https://stripe.com](https://stripe.com)

### 🔍 Views

Most views use Django REST Framework’s CBVs (`ListAPIView`, `CreateAPIView`, etc.).  
Custom views include:

- `UploadCustomerImage`: creates a product from client-uploaded vinyl
- Combined views for order + payment creation

---

## 🚀 Quickstart


### 🛠️ Preparing the Docker Image
1. Clone the repo

```bash
git clone https://github.com/jonathan-priebe/truck_signs_api.git
cd truck_signs_api
```

1. Copy and Configure the content of the example env file that is inside the truck_signs_designs folder into a .env file:
```bash
cd truck_signs_designs/settings
cp simple_env_config.env .env
```

1. Create volumes and network

```bash
docker volume create truck-sing-api-db
docker volume create truck-sing-api-api
docker network create trucknet
```
### 🐳 How to Build the Docker Image

To build the Django backend image locally, run:

```bash
docker build -t test-truck .
```

### ⚙️ Setup the Rest

1. Start PostgreSQL (Postgres 13)

```bash
docker run -d \
  --name db-truck \
  --restart on-failure \
  --network trucknet \
  -e POSTGRES_USER=YOUR_DB_USER \
  -e POSTGRES_PASSWORD=YOUR_DB_PASSWORD \
  -e POSTGRES_DB=YOUR_DB_NAME \
  -v truck-sing-api-db:/var/lib/postgresql/data \
  postgres:13
```

1. Start the Django API

```bash
docker run -p 8020:8000 -d \
  --name truck-sings \
  --restart on-failure \
  --network trucknet \
  -e DJANGO_SUPERUSER_USERNAME=YOUR_BACKEND_USER \
  -e DJANGO_SUPERUSER_PASSWORD=YOUR_BACKEND_PASSWORD \
  -e DJANGO_SUPERUSER_EMAIL=YOUR_BACKEND_EMAIL \
  -v truck-sing-api-api:/app \
  test-truck:latest
```
  - Configure these to access your Backend on [localhost:8020/admin](http://localhost:8020/admin)
    - YOUR_BACKEND_USER
    - YOUR_BACKEND_PASSWORD
    - YOUR_BACKEND_EMAIL

1. Congratulations 👍 !!! The App should be running in [localhost:8000/admin](http://localhost:8000/admin)

## 🚦 Usage
1. Configure the environment variables.
    1. The new .env file should contain all the environment variables necessary to run all the django app in all the environments. However, the only needed variables for the development environment to run are the following:
        ```bash
        SECRET_KEY
        IP_ADDR
        DB_NAME
        DB_USER
        DB_PASSWORD
        DB_HOST
        DB_PORT
        STRIPE_PUBLISHABLE_KEY
        STRIPE_SECRET_KEY
        EMAIL_HOST_USER
        EMAIL_HOST_PASSWORD
        ```
    1. For the database, the default configurations should be:
        ```bash
        IP_ADDR=YOUR_IP
        DB_NAME=YOUR_DB_NAME
        DB_USER=YOUR_DB_USER
        DB_PASSWORD=YOUR_DB_PASSWORD
        DB_HOST=localhost
        DB_PORT=5432
        ```
    1. To start the Django API on DEBUG-Mode add the DEBUG=true:
        ```bash
        docker run -p 8020:8000 -d \
          --name truck-sings \
          --restart on-failure \
          --network trucknet \
          -e DEBUG=true \
          -e DJANGO_SUPERUSER_USERNAME=YOUR_BACKEND_USER \
          -e DJANGO_SUPERUSER_PASSWORD=YOUR_BACKEND_PASSWORD \
          -e DJANGO_SUPERUSER_EMAIL=YOUR_BACKEND_EMAIL \
          -v truck-sing-api-api:/app \
          test-truck:latest
        ```

    1. The SECRET_KEY is the django secret key. To generate a new one see: [Stackoverflow Link](https://stackoverflow.com/questions/41298963/is-there-a-function-for-generating-settings-secret-key-in-django)

    1. **NOTE: not required for exercise**<br/>The STRIPE_PUBLISHABLE_KEY and the STRIPE_SECRET_KEY can be obtained from a developer account in [Stripe](https://stripe.com/). 
        - To retrieve the keys from a Stripe developer account follow the next instructions:
            1. Log in into your Stripe developer account (stripe.com) or create a new one (stripe.com > Sign Up). This should redirect to the account's Dashboard.
            1. Go to Developer > API Keys, and copy both the Publishable Key and the Secret Key.

    1. The EMAIL_HOST_USER and the EMAIL_HOST_PASSWORD are the credentials to send emails from the website when a client makes a purchase. This is currently disable, but the code to activate this can be found in views.py in the create order view as comments. Therefore, any valid email and password will work.

> [!NOTE]  
> To create Truck vinyls with Truck logos in them, first create the __Category__ Truck Sign, and then the __Product__ (can have any name). This is to make sure the frontend retrieves the Truck vinyls for display in the Product Grid as it only fetches the products of the category Truck Sign.

---

### 🖼️ Screenshots

### 📱 Mobile View

<div align="center">

![Mobile 1](./screenshots/Admin_Panel_View_Mobile.png)
![Mobile 2](./screenshots/Admin_Panel_View_Mobile_2.png)
![Mobile 3](./screenshots/Admin_Panel_View_Mobile_3.png)

</div>

### 💻 Desktop View

![Desktop 1](./screenshots/Admin_Panel_View.png)
![Desktop 2](./screenshots/Admin_Panel_View_2.png)
![Desktop 3](./screenshots/Admin_Panel_View_3.png)

## 🔗 Useful Links

### PostgreSQL
- [DigitalOcean: Django + Postgres + Nginx](https://www.digitalocean.com/community/tutorials/how-to-set-up-django-with-postgres-nginx-and-gunicorn-on-ubuntu-16-04)

### Docker
- [Docker Docs](https://docs.docker.com/)
- [Dockerizing Django](https://testdriven.io/blog/dockerizing-django-with-postgres-gunicorn-and-nginx/)

### Django & DRF
- [Django Docs](https://docs.djangoproject.com/en/4.0/)
- [DRF Docs](https://www.django-rest-framework.org/)
- [Customize Django Admin](https://realpython.com/customize-django-admin-python/)
- [Nested Serializers](https://stackoverflow.com/questions/51182823/django-rest-framework-nested-serializers)

### Misc
- [Virtualenv Guide](https://docs.python-guide.org/dev/virtualenvs/)
- [CORS Setup](https://www.stackhawk.com/blog/django-cors-guide/)
- [Cloudinary Integration](https://cloudinary.com/documentation/django_integration)
