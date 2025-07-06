ARG DEBIAN_VERSION=bullseye-slim

FROM debian:${DEBIAN_VERSION}

RUN apt update -y
RUN apt install -y wget curl
RUN apt install -y php php-cgi php-mysql php-fpm php-pdo php-gd php-cli php-xml php-mbstring

ENV WP_CLI_VERSION=2.11.0
RUN curl -sSL https://github.com/wp-cli/wp-cli/releases/download/v${WP_CLI_VERSION}/wp-cli-${WP_CLI_VERSION}.phar -o wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

COPY ./config/launch_wrapper.sh /usr/local/bin/launch_wrapper.sh
RUN chmod +x /usr/local/bin/launch_wrapper.sh

ENTRYPOINT ["/usr/local/bin/launch_wrapper.sh"]

WORKDIR /var/www/wordpress/

CMD ["/usr/sbin/php-fpm7.4", "-F"]
