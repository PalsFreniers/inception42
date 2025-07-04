ARG DEBIAN_VERSION=bullseye-slim

FROM debian:${DEBIAN_VERSION}

RUN apt update -y
RUN apt install -y nginx openssl

# Catch the current (docker's) nginx's configure options
#RUN nginx -V 2>&1 | grep "configure arguments" > /tmp/nginx-configure-args.txt

# Create a self-signed certificate
ENV NGINX_CERTS_DIR=/etc/nginx/certs
RUN mkdir -p $NGINX_CERTS_DIR

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout ${NGINX_CERTS_DIR}/ssl.key \
		-out ${NGINX_CERTS_DIR}/ssl.crt \
		-subj "/C=FR/ST=Nouvelle Aquitaine/L=Angoulême/O=42 Angoulême/CN=tdelage"

# Start Nginx (no daemon)
CMD ["nginx", "-g", "daemon off;"]
