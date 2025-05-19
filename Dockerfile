# Étape 1 : builder Flutter Web
FROM ghcr.io/cirruslabs/flutter:stable AS builder
WORKDIR /app

# Activer le support Web 
RUN flutter config --enable-web

# 1. Copier pubspec & récupérer les dépendances
COPY pubspec.* ./
RUN flutter pub get

# 2. Copier le reste du code et compiler
COPY . .
RUN flutter build web --release

# Étape 2 : serveur statique (Nginx)
FROM nginx:alpine
# Copier le build Web depuis l’étape précédente
COPY --from=builder /app/build/web /usr/share/nginx/html

# Exposer le port 80 pour tester localement
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
