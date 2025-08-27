# Base image with Python
FROM python:3.12-slim

# Install Node.js and MySQL client
RUN apt-get update && \
    apt-get install -y curl git build-essential default-mysql-client netcat-openbsd && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean


# Create working directory and copy source files
WORKDIR /app
COPY package*.json server.js ./

COPY src/ src/

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Install Node.js dependencies
RUN npm install

# Copy entrypoint script and make it executable
COPY entrypoint.sh .
RUN sed -i 's/\r$//' entrypoint.sh
RUN chmod +x entrypoint.sh

# Start using entrypoint
CMD ["./entrypoint.sh"]
