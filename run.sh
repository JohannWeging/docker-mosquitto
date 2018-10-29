#!/bin/sh

set -ex

env

mkdir -p "${MQ_PERSISTENCE_LOCATION}"
touch "${MQ_PERSISTENCE_LOCATION}${MQ_PERSISTENCE_FILE}"
chown -R mosquitto:mosquitto "${MQ_PERSISTENCE_LOCATION}"

mkdir -p "$(dirname ${CONFIG_FILE})"
touch "${CONFIG_FILE}"
mkdir -p "$(dirname ${MQ_PASSWORD_FILE})"
touch "${MQ_PASSWORD_FILE}"

setup-mosquitto

cat "${CONFIG_FILE}"
chown root:mosquitto "${CONFIG_FILE}"
chmod 0640 "${CONFIG_FILE}"
chown root:mosquitto "${MQ_PASSWORD_FILE}"
chmod 0640 "${MQ_PASSWORD_FILE}"

gosu mosquitto mosquitto -c ${CONFIG_FILE}
