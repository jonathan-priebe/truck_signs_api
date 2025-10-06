# Python Image for Project
FROM python:3.8-slim

# Install netcat and build tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    netcat-openbsd \
    gcc \
    build-essential \
    python3-dev \
 && rm -rf /var/lib/apt/lists/*

# Set Workdirectory
WORKDIR /app

# Copie Project files
COPY . /app

# Install dependencies & entrypoint.sh executable
RUN python -m pip install --no-cache-dir -r requirements.txt && \
    chmod +x /app/entrypoint.sh

# Expose Port
EXPOSE 8000

# Run Backend-Server
ENTRYPOINT ["/bin/sh", "-c", "/app/entrypoint.sh"]