# --- Stage 1: Builder ---
FROM node:20 AS builder

WORKDIR /app

COPY package*.json ./
# Install all dependencies (including devDependencies if you have them)
RUN npm install

COPY . .

# --- Stage 2: Final Production ---
FROM node:20-alpine

WORKDIR /app

# Copy only the package files and installed node_modules from the builder stage
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/server.js ./

EXPOSE 8080

# Run the app
CMD ["node", "server.js"]
