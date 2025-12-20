FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Copy backend requirements
COPY backend/requirements.txt ./backend/

# Install Python dependencies
RUN pip install --no-cache-dir -r backend/requirements.txt

# Install additional API dependencies
RUN pip install --no-cache-dir fastapi uvicorn[standard] psycopg2-binary

# Copy application
COPY backend/ ./backend/
COPY frontend/ ./frontend/

WORKDIR /app/backend/api

# Expose port
EXPOSE 8000

# Run server
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
