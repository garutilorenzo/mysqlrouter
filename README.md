# MySQL Router docker image

* [MySQL Router](https://dev.mysql.com/doc/mysql-router/8.0/en/) - MySQL Router is part of InnoDB Cluster, and is lightweight middleware that provides transparent routing between your application and back-end MySQL Servers

## Differences from official mysql router image

* MySQL Router runs in /app/mysqlrouter
* MySQL Router persist configurations on /app/mysqlrouter path (if volume is attached see docker-compose.yml)
* MySQL Router run a "bootstrap" only if no configuration is found in /app/mysqlrouter
* Healtcheck is disabled by default, it can be enabled if necessary (see docker-compose.yml.healtcheck)
* MySQL Router doesn't wait for all cluster members to be up

## Environment variables
* MYSQL_HOST: master node
* MYSQL_PORT: mysql port
* MYSQL_USER: mysql user with necessary grants
* MYSQL_PASSWORD: mysql user password
* MYSQL_HC_USER: mysql healtcheck user with necessary grants (optional)
* MYSQL_HC_PASWORD: mysql healtcheck user password (optional)

![MySQL Router Build](https://github.com/garutilorenzo/mysqlrouter/actions/workflows/docker-image.yml/badge.svg)
