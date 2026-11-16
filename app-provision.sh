#!/bin/bash

set -e

echo "Starting application provisioning..."


apt-get update -y


apt-get install -y \
    openjdk-17-jdk \
    git \
    curl \
    mysql-client


if ! id "$APP_USER" >/dev/null 2>&1; then
    useradd -m -s /bin/bash "$APP_USER"
fi


mkdir -p "$PROJECT_DIR"

chown -R "$APP_USER:$APP_USER" /opt


if [ ! -d "$PROJECT_DIR/.git" ]; then

    sudo -u "$APP_USER" git clone \
    https://github.com/spring-projects/spring-petclinic.git \
    "$PROJECT_DIR"

fi


chmod +x "$PROJECT_DIR/mvnw"


cd "$PROJECT_DIR"


sudo -u "$APP_USER" ./mvnw clean package

echo "Maven build completed!"


JAR_FILE=$(find "$PROJECT_DIR/target" \
    -maxdepth 1 \
    -name "*.jar" \
    ! -name "*.original" \
    | head -n 1)

if [ -z "$JAR_FILE" ]; then
    echo "JAR file not found!"
    exit 1
fi


mkdir -p "$APP_DIR"

cp "$JAR_FILE" "$APP_DIR/petclinic.jar"

chown -R "$APP_USER:$APP_USER" "$APP_DIR"


export MYSQL_PWD="$DB_PASS"

mysql \
    --connect-timeout=10 \
    -h "$DB_HOST" \
    -P "$DB_PORT" \
    -u "$DB_USER" \
    "$DB_NAME" \
    -e "SELECT 1;"

unset MYSQL_PWD


cat > /etc/systemd/system/petclinic.service <<EOF
[Unit]
Description=Spring PetClinic
After=network-online.target
Wants=network-online.target

[Service]
User=${APP_USER}
WorkingDirectory=${APP_DIR}

Environment="SPRING_PROFILES_ACTIVE=mysql"

Environment="SPRING_DATASOURCE_URL=jdbc:mysql://${DB_HOST}:${DB_PORT}/${DB_NAME}"
Environment="SPRING_DATASOURCE_USERNAME=${DB_USER}"
Environment="SPRING_DATASOURCE_PASSWORD=${DB_PASS}"

ExecStart=/usr/bin/java -jar ${APP_DIR}/petclinic.jar

Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF


systemctl daemon-reload
systemctl enable petclinic
systemctl restart petclinic

echo "PetClinic deployment completed!"

echo "Application IP: 192.168.56.10"
echo "Application port: 8080"

