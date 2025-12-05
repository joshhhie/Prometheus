# ObfusQ - Roblox Luau Obfuscator Docker Image
# Multi-stage build for optimal image size

# Stage 1: Build stage
FROM node:18-slim as builder

WORKDIR /app

# Install Lua and required dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    lua5.1 \
    lua5.1-dev \
    build-essential \
    wget \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Copy package files
COPY package.json package-lock.json* ./

# Install Node dependencies
RUN npm ci --omit=dev

# Stage 2: Runtime stage
FROM node:18-slim

WORKDIR /app

# Install Lua runtime only
RUN apt-get update && apt-get install -y --no-install-recommends \
    lua5.1 \
    && rm -rf /var/lib/apt/lists/*

# Copy Node modules from builder
COPY --from=builder /app/node_modules ./node_modules

# Copy application files
COPY package.json ./
COPY server.js ./
COPY public/ ./public/
COPY src/ ./src/

# Create non-root user for security
RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /app
USER appuser

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/health || exit 1

# Start the application
CMD ["npm", "start"]
