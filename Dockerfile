FROM node:13.12.0-alpine as builder
WORKDIR /app
COPY ./Semantic-Front .
RUN yarn
RUN yarn build

FROM nginx
ARG HOST
ARG REST_NAME
ARG ES_NAME
COPY --from=0 /app/build /var/www/$HOST/html
RUN rm -f /etc/nginx/conf.d/default*
COPY nginx.conf /tmp/nginx.conf
COPY uwsgi_params /etc/nginx/conf.d/uwsgi_params
RUN envsubst '$$HOST $$REST_NAME $$ES_NAME' < /tmp/nginx.conf > /etc/nginx/conf.d/nginx.conf
RUN apt update
RUN apt install certbot -y
RUN apt install python3-certbot -y
RUN apt install python-certbot-nginx -y
ENV DOMAIN=$HOST
CMD (certbot run --nginx --register-unsafely-without-email --force-renewal --post-hook "nginx -t -c /etc/nginx/nginx.conf" --agree-tos --redirect -d $DOMAIN -d www.$DOMAIN \
	&& nginx -s reload) & nginx -g 'daemon off;'
#CMD nginx -g 'daemon off;'
