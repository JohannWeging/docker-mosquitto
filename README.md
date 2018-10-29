[![Build Status](https://ci.sysexit.com/api/badges/JohannWeging/docker-mosquitto/status.svg)](https://ci.sysexit.com/JohannWeging/docker-mosquitto) [![Docker Hub](https://img.shields.io/badge/docker-container-blue.svg?longCache=true&style=flat-square)](https://hub.docker.com/r/johannweging/mosquitto) [![GitHub](https://img.shields.io/badge/github-repo-blue.svg?longCache=true&style=flat-square)](https://github.com/JohannWeging/docker-mosquitto)
# Mosquitto Docker Container
Mosquitto MQTT Broker Docker Container (amd54, arm32v6)

The container is configured using ENVs in the format of `MQ_CONF_VAR=value`.

```
# disable anonymous auth
docker run -e MQ_ALLOW_ANONYMOUS=false johannweging/mosquitto
```

Users are added by index:
```
docker run -e USER_NAME_1=foo -e USER_PASSWORD_1=bar -e MQ_ALLOW_ANONYMOUS=false johannweging/mosquitto
```

Persisting MQTT data:
```
docker run -v data:/var/lib/mosquitto -e MQ_PERSISTENCE=true johannweging/mosquitto
# custom location trailing / required
docker run -v data:/data -e MQ_PERSISTENCE_LOCATION=/data/ MQ_PERSISTENCE=true johannweging/mosquitto
```

Custom user password file:
```
docker run -v data:/data -e MQ_ALLOW_ANONYMOUS=false -e MQ_PASSWORD_FILE=/data/pwfile johannweging/mosquitto
```

Custom config file, if you want to mount one:
```
# IMPORTANT ENV config keys are simply appended to the file not overwritten!
docker run -v conf:/conf -e CONFIG_FILE=/conf/conf.conf johannweging/mosquitto
```

## Architectures
The image supports `amd64` and `arm32v6`.
```
docker run johannweging/mosquitto:latest-arm32v6
```

