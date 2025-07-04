#!/bin/bash

WP_DIR=/var/www/wordpress
WP_UNIX_USER=www-data
WORDPRESS_VERSION=6.7.1

if [ -f "${WP_DIR}/wp-config.php" ]; then
	echo "[*] Wordpress already installed, skipping installation"
else
	echo "[*] Wordpress not installed, installing"
	ls -la ${WP_DIR}
	echo "[*] Downloading Wordpress ${WORDPRESS_VERSION}"
	wp --allow-root core download --version=${WORDPRESS_VERSION} --path=${WP_DIR}
	wp --allow-root core config --dbname=${MARIADB_DATABASE} --dbuser=${MARIADB_USER} --dbpass=${MARIADB_PASSWORD} --dbhost=${MARIADB_HOSTNAME} --dbprefix=wp_ --path=${WP_DIR}
	wp --allow-root core install --url=https://${PROJECT_URL} --title="${WP_TITLE}" --admin_user=${WP_ADMIN_USER} --admin_password=${WP_ADMIN_PASSWORD} --admin_email=${WP_ADMIN_EMAIL} --path=${WP_DIR}
	wp --allow-root user create ${WP_USER} ${WP_USER_EMAIL} --user_pass=${WP_USER_PASSWORD} --role=author --path=${WP_DIR}
fi

if [ ! -d /run/php ]; then
 	mkdir -p /run/php
fi

chown -R ${WP_UNIX_USER}:${WP_UNIX_USER} /run/php

echo "[*] Starting php-fpm"
exec "$@"
