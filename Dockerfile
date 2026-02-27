FROM nginx:1.25.3-alpine

# Création utilisateur non-root
RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup

# Droits Nginx
RUN touch /var/run/nginx.pid && \
    chown -R appuser:appgroup /var/run/nginx.pid /var/cache/nginx /var/log/nginx /etc/nginx/conf.d

COPY --chown=appuser:appgroup nginx/nginx.conf /etc/nginx/conf.d/default.conf
COPY --chown=appuser:appgroup src/ /usr/share/nginx/html/

USER appuser
EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]