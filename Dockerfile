<<<<<<< HEAD
FROM nginx:alpine
# Métadonnées
LABEL maintainer="TP DevOps"
LABEL description="Application DevOps optimisée"
# Copier en une seule couche
COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf
COPY src/ /usr/share/nginx/html/
# Supprimer les fichiers inutiles
RUN rm -rf /usr/share/nginx/html/*.md
EXPOSE 80
HEALTHCHECK --interval=30s --timeout=3s CMD wget -q --spider http://localhost/ || e
CMD ["nginx", "-g", "daemon off;"]
=======
# Remplacement de l'image de base
FROM nginx:1.25-alpine

# Préparation technique des droits
RUN touch /var/run/nginx.pid && \
    chown -R nginx:nginx /var/run/nginx.pid /var/cache/nginx /var/log/nginx /etc/nginx/conf.d

# Remplacement des copies simples par des copies sécurisées
COPY --chown=nginx:nginx nginx/nginx.conf /etc/nginx/conf.d/default.conf
COPY --chown=nginx:nginx src/ /usr/share/nginx/html/

# Changement d'utilisateur (Remplacement du mode root par défaut)
USER nginx

EXPOSE 80
HEALTHCHECK --interval=30s --timeout=3s CMD wget --quiet --tries=1 --spider http://localhost/ || exit 1

CMD ["nginx", "-g", "daemon off;"]
>>>>>>> 58e7ce3 (TP2: Securisation Docker et CI/CD)
