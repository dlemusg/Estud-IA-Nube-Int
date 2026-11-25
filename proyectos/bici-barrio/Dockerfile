# BiciBarrio · API de préstamo de bicicletas
FROM node:22-slim

ENV NODE_ENV=production PORT=3000
WORKDIR /app

# Primero las dependencias: esta capa se reutiliza mientras package*.json no cambie
COPY package.json package-lock.json ./
RUN npm ci --omit=dev

COPY src/ src/

# La imagen oficial de Node ya trae un usuario sin privilegios llamado node
USER node

EXPOSE 3000
CMD ["node", "src/server.js"]
