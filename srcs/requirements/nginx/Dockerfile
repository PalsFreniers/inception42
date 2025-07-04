ARG DEBIAN_VERSION=bullseye-slim

FROM debian:${DEBIAN_VERSION}

RUN apt update -y
RUN apt install -y nginx openssl

RUN apt install -y git build-essential cmake wget tar

ENV BROTLI_NGX_REV=a71f9312c2deb28875acc7bacfdd5695a111aa53
ENV NGINX_VERSION=1.18.0

RUN git clone --recurse-submodules -j8 https://github.com/google/ngx_brotli.git /tmp/ngx_brotli
WORKDIR /tmp/ngx_brotli
RUN git checkout $BROTLI_NGX_REV 
RUN mkdir /tmp/ngx_brotli/deps/brotli/out -p

# Build ngx_brotli and its dependencies
WORKDIR /tmp/ngx_brotli/deps/brotli/out
RUN cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DCMAKE_C_FLAGS="-Ofast -m64 -march=native -mtune=native -flto -funroll-loops -ffunction-sections -fdata-sections -Wl,--gc-sections" -DCMAKE_CXX_FLAGS="-Ofast -m64 -march=native -mtune=native -flto -funroll-loops -ffunction-sections -fdata-sections -Wl,--gc-sections" -DCMAKE_INSTALL_PREFIX=./installed ..
RUN cmake --build . --config Release --target brotlienc

##> Download and build nginx modules <##

# Download nginx
RUN wget -O /tmp/nginx.tar.gz \
	http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz
WORKDIR /tmp
RUN tar -xvzmf nginx.tar.gz
WORKDIR /tmp/nginx-${NGINX_VERSION}

# Catch the current (docker's) nginx's configure options
RUN nginx -V 2>&1 | grep "configure arguments" > /tmp/nginx-configure-args.txt

# Get deps for nginx
RUN apt install -y libpcre3 libpcre3-dev libssl-dev zlib1g-dev libxslt1-dev libgd-dev

# Build nginx modules with Brotli
RUN sh -c "./configure \
	--with-compat --add-dynamic-module=/tmp/ngx_brotli \
	$(cat /tmp/nginx-configure-args.txt | cut -d' ' -f3-)"
RUN make modules -j$(nproc)

# Copy the module to the nginx modules directory
RUN mkdir -p /etc/nginx/modules
RUN cp objs/ngx_http_brotli_filter_module.so /etc/nginx/modules
RUN cp objs/ngx_http_brotli_static_module.so /etc/nginx/modules

# Create a self-signed certificate
ENV NGINX_CERTS_DIR=/etc/nginx/certs
RUN mkdir -p $NGINX_CERTS_DIR

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout ${NGINX_CERTS_DIR}/ssl.key \
		-out ${NGINX_CERTS_DIR}/ssl.crt \
		-subj "/C=FR/ST=Nouvelle Aquitaine/L=Angoulême/O=42 Angoulême/CN=tdelage"

# Expose the HTTPS port
EXPOSE 443

# Start Nginx (no daemon)
CMD ["nginx", "-g", "daemon off;"]
