FROM nginx:1.25.3-alpine

# Créer un utilisateur non-root (Sécurité recommandée)
RUN addgroup -g 1000 -S appgroup && \
    adduser -u 1000 -S appuser -G appgroup

# Installation minimale
RUN apk add --no-cache ca-certificates && rm -rf /var/cache/apk/*

# Copie avec droits restreints
COPY --chown=appuser:appgroup nginx/nginx.conf /etc/nginx/conf.d/default.conf
COPY --chown=appuser:appgroup src/ /usr/share/nginx/html/

# Gestion des permissions pour Nginx en mode non-root
RUN touch /var/run/nginx.pid && \
    chown -R appuser:appgroup /var/run/nginx.pid /var/cache/nginx /usr/share/nginx/html

USER appuser
EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://localhost:8080/ || exit 1

CMD ["nginx", "-g", "daemon off;"]