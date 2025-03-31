# Étape 1 : Construction de l'application (builder)
FROM node:18-alpine as builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --silent  # Installation stricte des dépendances (plus rapide que npm install)
COPY . .
RUN npm run build  # Génère le dossier /app/build

# Étape 2 : Serveur de production
FROM nginx:alpine
# Copie des fichiers compilés de React
COPY --from=builder /app/build /usr/share/nginx/html
# Configuration Nginx pour le routage (nécessaire pour React Router)
COPY nginx.conf /etc/nginx/conf.d/default.conf
# Exposition du port et démarrage
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
