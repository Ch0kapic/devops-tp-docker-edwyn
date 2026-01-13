# Utilisation d'une image versionnée (Fix DL3006 / DL3007)
FROM nginx:1.25.3-alpine

# Création d'un utilisateur non-privilégié
RUN addgroup -g 1000 -S appgroup && \
    adduser -u 1000 -S appuser -G appgroup

# Nettoyage des caches APK pour réduire la surface d'attaque (Fix DL3018)
RUN apk add --no-cache ca-certificates=20241121-r1 && rm -rf /var/cache/apk/*

# Configuration des droits pour l'utilisateur non-root
RUN touch /var/run/nginx.pid && \
    chown -R appuser:appgroup /var/run/nginx.pid /var/cache/nginx /var/log/nginx /etc/nginx/conf.d

# Copie des fichiers avec changement de propriétaire immédiat (Fix DL3010)
COPY --chown=appuser:appgroup nginx/nginx.conf /etc/nginx/conf.d/default.conf
COPY --chown=appuser:appgroup src/ /usr/share/nginx/html/

# Application du principe de moindre privilège
USER appuser

# Utilisation du port 8080 (obligatoire pour non-root)
EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://localhost:8080/ || exit 1

CMD ["nginx", "-g", "daemon off;"]