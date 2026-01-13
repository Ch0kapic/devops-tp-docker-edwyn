# 1. Image fixe (Hadolint valide)
FROM nginx:1.25.3-alpine

# 2. Création d'un utilisateur non-root (ID > 1000)
RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup

# 3. Préparation des dossiers avec les bons droits
RUN touch /var/run/nginx.pid && \
    chown -R appuser:appgroup /var/run/nginx.pid /var/cache/nginx /var/log/nginx /etc/nginx/conf.d

# 4. Copie des fichiers (Assure-toi que les dossiers 'src' et 'nginx' existent)
COPY --chown=appuser:appgroup nginx/nginx.conf /etc/nginx/conf.d/default.conf
COPY --chown=appuser:appgroup src/ /usr/share/nginx/html/

# 5. On bascule sur l'utilisateur restreint
USER appuser

# 6. Port 8080 (obligatoire car l'utilisateur n'a pas les droits sur le port 80)
EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://localhost:8080/ || exit 1

CMD ["nginx", "-g", "daemon off;"]
