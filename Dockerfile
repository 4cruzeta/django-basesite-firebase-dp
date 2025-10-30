# Use an official Python runtime as a parent image
FROM python:3.13-slim

# Set environment variables for Python
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set the working directory in the container
WORKDIR /app

# Install Node.js and npm for Tailwind CSS
RUN apt-get update && apt-get install -y curl && \
    curl -sL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Install uv, a fast Python package installer
RUN pip install uv

# Copy the requirements file and install Python dependencies
COPY requirements.txt .
RUN uv pip install --no-cache-dir -r requirements.txt --system

# Copy the entire project directory into the container
COPY . .

# Install npm dependencies and build the Tailwind CSS
RUN cd /app/basesite/theme/static_src && \
    npm install && \
    npm run build

# Run Django's collectstatic to gather all static files
RUN python basesite/manage.py collectstatic --noinput

# Expose the port the app runs on
EXPOSE 8080

# Run the startup script
CMD ["./run.sh"]
