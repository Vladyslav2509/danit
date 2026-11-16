#!/bin/bash

set -e

echo "Starting MySQL installation..."


apt-get update -y


DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server


cat > /etc/mysql/mysql.conf.d/mysqld.cnf <<EOF
[mysqld]
user = mysql
bind-address = ${DB_IP}
mysqlx-bind-address = 127.0.0.1
EOF


systemctl enable mysql
systemctl restart mysql


for i in {1..30}; do
    if mysqladmin ping --silent; then
        break
    fi
    sleep 2
done


mysql <<EOF

CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;

CREATE USER IF NOT EXISTS
'${DB_USER}'@'192.168.56.%'
IDENTIFIED BY '${DB_PASS}';

ALTER USER '${DB_USER}'@'192.168.56.%'
IDENTIFIED BY '${DB_PASS}';

GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.*
TO '${DB_USER}'@'192.168.56.%';

FLUSH PRIVILEGES;

EOF


apt-get install -y ufw

ufw allow OpenSSH
ufw allow from 192.168.56.0/24 to any port 3306 proto tcp

ufw --force enable

echo "MySQL configuration completed!"

echo "Database: ${DB_NAME}"
echo "User: ${DB_USER}"
echo "IP: ${DB_IP}"

