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
