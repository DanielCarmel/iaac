# Stage 1: Build stage
FROM python:3.11-slim AS builder

# Set working directory
WORKDIR /app

# Copy requirements file and install dependencies
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files into the build stage
COPY . .

# Stage 2: Final stage
FROM python:3.11-slim

# Set working directory
WORKDIR /app


# Copy only necessary files from the build stage
COPY --from=builder /usr/local/lib/python3.11/site-packages/ /usr/local/lib/python3.11/site-packages/
COPY --from=builder /app /app

EXPOSE 3000

# Command to run the application
CMD ["python", "app.py"]
