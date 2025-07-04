#!/bin/bash

# Environment variables:
# - MARIADB_HOSTNAME
# - MARIADB_DATABASE
# - MARIADB_USER
# - MARIADB_PASSWORD
# - MARIADB_ROOT_PASSWORD

echo "[*] Loading database in temporary init mode"
service mariadb start

if [ -d "/var/lib/mysql/${MARIADB_DATABASE}" ]; then
	echo "[*] Database already exists, skipping creation"
else
	echo "[*] Database does not exist, ensuring MariaDB is setup"

	# (we installed bash in Dockerfile just so we can use tabbed heredocs here, nice.)
	mariadb-secure-installation <<-EOF
		
		y
		y
		${MARIADB_ROOT_PASSWORD}
		${MARIADB_ROOT_PASSWORD}
		y
		y
		y
		y
	EOF

	echo "[*] Creating database"
	mysql -u root -p${MARIADB_ROOT_PASSWORD} -e "CREATE DATABASE ${MARIADB_DATABASE};"
	echo "[*] Creating user"
	mysql -u root -p${MARIADB_ROOT_PASSWORD} -e "CREATE USER '${MARIADB_USER}'@'%' IDENTIFIED BY '${MARIADB_PASSWORD}';"
	echo "[*] Granting privileges"
	mysql -u root -p${MARIADB_ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON ${MARIADB_DATABASE}.* TO '${MARIADB_USER}'@'%';"
	echo "[*] Flushing privileges"
	mysql -u root -p${MARIADB_ROOT_PASSWORD} -e "FLUSH PRIVILEGES;"
fi

echo "[*] Stopping temp init mode"
kill $(cat /var/run/mysqld/mysqld.pid)

echo "[*] Launching MariaDB"
exec "$@"

# vim: set ft=sh ts=4 sw=4
