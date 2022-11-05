#!/usr/bin/env bash

set -Eeu

msg() {
  echo >&2 -e "${1-}"
}

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

RANDOM_NUMBER=${RANDOM_NUMBER:-"$(date +%s)"}

POSTGRES_USER=${POSTGRES_USER:-"challenger"}
POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-"T2xKc2L1GR"}
POSTGRES_PORT=${POSTGRES_PORT:-"5432"}
POSTGRES_DB=${POSTGRES_DB:-"incrmntal"}
POSTGRES_VERSION=${POSTGRES_VERSION:-"14.2"}
POSTGRES_TAG=${POSTGRES_TAG:-"${POSTGRES_VERSION}-alpine"}
FLYWAY_VERSION=${FLYWAY_VERSION:-"8.5.2"}
FLYWAY_TAG=${FLYWAY_TAG:-"${FLYWAY_VERSION}-alpine"}

POSTGRES_CONTAINER=${POSTGRES_CONTAINER:-"incrmntal-challenge"}
POSTGRES_LOGFILE=${POSTGRES_LOGFILE:-".postgres.log"}
POSTGRES_IMAGE=${POSTGRES_IMAGE:-"elemental"}

FLYWAY_CONTAINER=${FLYWAY_CONTAINER:-"flyway_${RANDOM_NUMBER}"}

DOCKER_NETWORK=${DOCKER_NETWORK:-"incrmntal_challenge_network"}


if docker network create "${DOCKER_NETWORK}" 2>&1 | grep -F 'already exists' >/dev/null 2>&1; then
    echo "network already exists"
fi

if docker ps --format '{{.Names}}' | grep "${POSTGRES_CONTAINER}" >/dev/null 2>&1; then
    echo "${POSTGRES_CONTAINER} already running"
else
    msg "Starting postgres container ${POSTGRES_CONTAINER} with ${POSTGRES_TAG}"
    docker run --name "${POSTGRES_CONTAINER}" --network "${DOCKER_NETWORK}" \
      -e POSTGRES_PASSWORD="${POSTGRES_PASSWORD}" \
      -e POSTGRES_USER="${POSTGRES_USER}" \
      -e POSTGRES_DB="${POSTGRES_DB}" \
      -p "${POSTGRES_PORT}:5432" \
      -d \
      postgres:"${POSTGRES_TAG}"

    sleep 1

    msg "Waiting for postgres to be ready..."
    docker logs -f "${POSTGRES_CONTAINER}" | grep -m1 -F 'database system is ready to accept connections'
fi

msg "Running flyway migration..."
docker run --rm --name "${FLYWAY_CONTAINER}" --network "${DOCKER_NETWORK}" \
  -v "$SCRIPT_DIR/migrations:/migrations" \
  "flyway/flyway:${FLYWAY_TAG}" \
  -user="${POSTGRES_USER}" \
  -password="${POSTGRES_PASSWORD}" \
  -url="jdbc:postgresql://${POSTGRES_CONTAINER}:${POSTGRES_PORT}/${POSTGRES_DB}" \
  -locations="filesystem:/migrations" \
  -initSql='DO
$do$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE  rolname = '"'postgres'"') THEN
      CREATE ROLE postgres;
   END IF;
END
$do$;' \
  migrate

