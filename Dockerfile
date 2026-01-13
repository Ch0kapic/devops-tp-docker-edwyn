# Utilisation d'une image de base fixe pour éviter le tag latest
FROM nginx:1.25.3-alpine3.19

# Création d'un utilisateur non-root pour la sécurité
RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup

# Installation de ca-certificates avec une version précise pour Hadolint
RUN apk add --no-cache ca-certificates=20241121-r0 && \
    rm -rf /var/cache/apk/*

# Configuration des permissions pour l'utilisateur non-root
RUN touch /var/run/nginx.pid && \
    chown -R appuser:appgroup /var/run/nginx.pid /var/cache/nginx /var/log/nginx /etc/nginx/conf.d

# Copie des fichiers avec changement de propriétaire
COPY --chown=appuser:appgroup nginx/nginx.conf /etc/nginx/conf.d/default.conf
COPY --chown=appuser:appgroup src/ /usr/share/nginx/html/

# Application de l'utilisateur restreint
USER appuser

# Exposition du port 8080 (obligatoire pour utilisateur non-root)
EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://localhost:8080/ || exit 1

CMD ["nginx", "-g", "daemon off;"]