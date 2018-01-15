FROM nginx:1.11-alpine

RUN apk -U add curl

COPY nginx/www.conf /etc/nginx/conf.d/default.conf
COPY nginx/nginx.conf /etc/nginx/nginx.conf
