#!/bin/sh

echo "Food Facts will start in ${APP_SLEEP}s..." && sleep ${APP_SLEEP}
exec java ${JAVA_OPTIONS} -Djava.security.egd=file:/dev/./urandom -jar "${HOME}/app.jar" "$@"