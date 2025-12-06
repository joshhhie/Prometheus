# Use Node.js as the base image
FROM node:18-alpine

# Install Lua 5.1 (required for Prometheus)
RUN apk add --no-cache lua5.1

# Set working directory
WORKDIR /app

# Copy package files
COPY package.json ./

# Install dependencies
RUN npm install

# Copy application source
COPY . .

# Expose port
EXPOSE 3000

# Start the server
CMD ["node", "server.js"]
