ARG DEBIAN_VERSION=bullseye-slim

FROM debian:${DEBIAN_VERSION}

RUN apt update -y
RUN apt install -y mariadb-server mariadb-client bash

RUN mkdir -p /run/mysqld
RUN chown -R mysql:mysql /run/mysqld
RUN chmod 777 /run/mysqld


COPY ./config/launch_wrapper.sh /usr/local/bin/launch_wrapper.sh
RUN chmod +x /usr/local/bin/launch_wrapper.sh

COPY ./config/mysqld.conf /etc/mysql/mysql.conf.d/50-web.conf

# Entrypoint
ENTRYPOINT ["/usr/local/bin/launch_wrapper.sh"]

# Expose the default port
EXPOSE 3306

# Launch the MariaDB server
CMD ["mysqld", "--bind-address=0.0.0.0"]
