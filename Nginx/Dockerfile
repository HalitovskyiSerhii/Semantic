FROM nginx
ARG HOST
ARG REST_NAME
ARG ES_NAME
COPY nginx /etc/nginx/conf.d/nginx.conf
COPY uwsgi_params /etc/nginx/conf.d/uwsgi_params
RUN rm -f /etc/nginx/conf.d/default*
RUN envsubst '$$HOST $$REST_NAME $$ES_NAME' < /etc/nginx/conf.d/nginx.conf > /etc/nginx/conf.d/nginx.conf
RUN apt install certbot -y
RUN apt install python3-certbot -y
RUN apt install python-certbot-nginx -y
RUN nginx -s stop

