ARG DEBIAN_VERSION=bullseye-slim

FROM debian:${DEBIAN_VERSION}

RUN apt update -y
RUN apt install -y nginx openssl

#RUN nginx -V 2>&1 | grep "configure arguments" > /tmp/nginx-configure-args.txt

ENV NGINX_CERTS_DIR=/etc/nginx/certs
RUN mkdir -p $NGINX_CERTS_DIR

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout ${NGINX_CERTS_DIR}/ssl.key \
		-out ${NGINX_CERTS_DIR}/ssl.crt \
		-subj "/C=FR/ST=Nouvelle Aquitaine/L=Angoulême/O=42 Angoulême/CN=tdelage"

CMD ["nginx", "-g", "daemon off;"]
