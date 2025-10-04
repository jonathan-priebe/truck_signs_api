# Python Image for Project
FROM python:3.8-buster

# Switch to archive mirror for Buster & Install netcat and build tools
RUN sed -i 's|http://deb.debian.org/debian|http://archive.debian.org/debian|g' /etc/apt/sources.list \
 && sed -i 's|http://security.debian.org/debian-security|http://archive.debian.org/debian-security|g' /etc/apt/sources.list \
 && echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid-until \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
    netcat \
    gcc \
    build-essential \
    python3-dev \
 && rm -rf /var/lib/apt/lists/*

# Set Workdirectory
WORKDIR /app

# Copie Project files
COPY . /app

# Install dependencies
RUN python -m pip install --no-cache-dir -r requirements.txt

# Make entrypoint.sh executable
RUN chmod +x /app/entrypoint.sh

# Expose Port
EXPOSE 8000

# Run Backend-Server
ENTRYPOINT ["/bin/sh", "-c", "/app/entrypoint.sh"]