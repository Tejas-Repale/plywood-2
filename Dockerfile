# =========================================================
# Stage 1 — Build Stage
# =========================================================
FROM python:3.11-slim AS builder

# Environment variables for build stage (no secrets here)
ARG APP_NAME
ARG APP_ENV=production
ARG APP_HOME=/app

# Set working directory
WORKDIR ${APP_HOME}

# Install build dependencies and security updates
RUN apt-get update -y && apt-get upgrade -y && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy dependency files first (for Docker layer caching)
COPY requirements.txt .

# Install Python dependencies into a temp directory
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt --target /install

# =========================================================
# Stage 2 — Runtime Stage (Slim Image)
# =========================================================
FROM python:3.11-alpine AS runtime

# Labels for metadata
LABEL maintainer="DevOps Team <devops@mycompany.com>" \
      description="Production-ready ${APP_NAME} container" \
      version="1.0"

# Environment
ENV PYTHONUNBUFFERED=1 \
    APP_HOME=/app \
    APP_ENV=${APP_ENV:-production} \
    PORT=8080 \
    TZ=UTC

# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Create app directory
WORKDIR ${APP_HOME}

# Copy Python packages from build stage
COPY --from=builder /install /usr/local/lib/python3.11/site-packages

# Copy application source code
COPY . ${APP_HOME}

# Healthcheck for ECS
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s CMD curl -f http://localhost:${PORT}/health || exit 1

# Switch to non-root user for security
USER appuser

# Expose container port (matches ECS container port variable)
EXPOSE ${PORT}

# Default entrypoint and command (no hardcoding)
ENTRYPOINT ["python"]
CMD ["app.py"]
