# 1. Image de base versionnée (Fix DL3006)
FROM nginx:1.25.3-alpine

# 2. Création d'un utilisateur non-root pour la sécurité
RUN addgroup -g 1000 -S appgroup && \
    adduser -u 1000 -S appuser -G appgroup

# 3. Installation minimale et nettoyage
RUN apk add --no-cache ca-certificates && rm -rf /var/cache/apk/*

# 4. Préparation des droits pour Nginx (dossiers de cache et PID)
RUN touch /var/run/nginx.pid && \
    chown -R appuser:appgroup /var/run/nginx.pid /var/cache/nginx /var/log/nginx /etc/nginx/conf.d

# 5. Copie des fichiers avec changement de propriétaire
COPY --chown=appuser:appgroup nginx/nginx.conf /etc/nginx/conf.d/default.conf
COPY --chown=appuser:appgroup src/ /usr/share/nginx/html/

# 6. Passage en utilisateur restreint
USER appuser

# Port 8080 requis car l'utilisateur non-root ne peut pas ouvrir le port 80
EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://localhost:8080/ || exit 1

CMD ["nginx", "-g", "daemon off;"]