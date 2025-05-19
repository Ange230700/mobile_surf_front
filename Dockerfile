# Dockerfile

# ---------- Stage 1: Build Flutter Web App ----------
FROM cirrusci/flutter:3.7.12 AS builder
WORKDIR /app

# 1. Declare build arguments
ARG API_BASE_URL

# 2. Install dependencies
COPY pubspec.* ./
RUN flutter pub get

# 3. Copy your source
COPY . .

# 4. Build, injecting your API_BASE_URL
RUN flutter build web --release \
    --dart-define=API_BASE_URL="$API_BASE_URL"

# ---------- Stage 2: Serve with Nginx ----------
FROM nginx:alpine

# Remove default Nginx content
RUN rm -rf /usr/share/nginx/html/*

# Copy built web files
COPY --from=builder /app/build/web /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
