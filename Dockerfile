FROM nginx:alpine

# Копируем конфиги nginx
COPY nginx.conf /etc/nginx/nginx.conf
COPY conf.d/ /etc/nginx/conf.d/
COPY sites/ /usr/share/nginx/html/

# Создаём папку под SSL и генерируем фиктивные сертификаты
# (реальные ключи будут монтироваться при деплое)
RUN mkdir -p /etc/nginx/ssl && \
    apk add --no-cache openssl && \
    openssl req -x509 -nodes -days 1 -newkey rsa:2048 \
      -keyout /etc/nginx/ssl/grafana.local.key \
      -out /etc/nginx/ssl/grafana.local.crt \
      -subj "/CN=grafana.local" && \
    openssl req -x509 -nodes -days 1 -newkey rsa:2048 \
      -keyout /etc/nginx/ssl/site1.local.key \
      -out /etc/nginx/ssl/site1.local.crt \
      -subj "/CN=site1.local" && \
    apk del openssl

# Проверяем синтаксис конфигов
RUN nginx -t

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
