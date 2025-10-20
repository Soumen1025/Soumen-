# Base image (latest stable & supported)
FROM python:3.10-slim-bullseye

# Set environment variables to prevent Python buffering and cache issues
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    DEBIAN_FRONTEND=noninteractive

# Install essential system dependencies
RUN apt-get update -y && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
       gcc \
       libffi-dev \
       musl-dev \
       ffmpeg \
       aria2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy your app files
WORKDIR /app
COPY . .

# Install Python dependencies
RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt \
    && pip install pytube

# Environment variable for cookies file
ENV COOKIES_FILE_PATH="youtube_cookies.txt"

# Expose port for Gunicorn (default 8000)
EXPOSE 8000

# Final command (run web + main script)
CMD gunicorn app:app --bind 0.0.0.0:8000 & python3 main.py
