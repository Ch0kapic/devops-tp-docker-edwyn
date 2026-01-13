# Utilisation d'une image alpine très stable
FROM nginx:1.25.3-alpine

# Création d'un utilisateur non-root sans installation de paquets superflus
RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup

# Configuration des droits indispensable pour Nginx
RUN touch /var/run/nginx.pid && \
    chown -R appuser:appgroup /var/run/nginx.pid /var/cache/nginx /var/log/nginx /etc/nginx/conf.d

# Copie des fichiers de ton TP 1
COPY --chown=appuser:appgroup nginx/nginx.conf /etc/nginx/conf.d/default.conf
COPY --chown=appuser:appgroup src/ /usr/share/nginx/html/

# Sécurité : On ne tourne plus en ROOT
USER appuser

# Obligatoire : port 8080 (les ports < 1024 sont réservés à root)
EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://localhost:8080/ || exit 1

CMD ["nginx", "-g", "daemon off;"]