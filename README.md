![MySQL Router Build](https://github.com/garutilorenzo/mysqlrouter/actions/workflows/docker-image.yml/badge.svg)
[![GitHub issues](https://img.shields.io/github/issues/garutilorenzo/mysqlrouter)](https://github.com/garutilorenzo/mysqlrouter/issues)
![GitHub](https://img.shields.io/github/license/garutilorenzo/mysqlrouter)
[![GitHub forks](https://img.shields.io/github/forks/garutilorenzo/mysqlrouter)](https://github.com/garutilorenzo/mysqlrouter/network)
[![GitHub stars](https://img.shields.io/github/stars/garutilorenzo/mysqlrouter)](https://github.com/garutilorenzo/laravel-docker/stargazers)

# MySQL Router docker image

* [MySQL Router](https://dev.mysql.com/doc/mysql-router/8.0/en/) - MySQL Router is part of InnoDB Cluster, and is lightweight middleware that provides transparent routing between your application and back-end MySQL Servers

## Differences from official mysql router image

* MySQL Router runs in /app/mysqlrouter
* MySQL Router persist configurations on /app/mysqlrouter path (if volume is attached see docker-compose.yml)
* MySQL Router run a [bootstrap](https://dev.mysql.com/doc/mysql-router/8.0/en/mysql-router-deploying-bootstrapping.html) only if no configuration is found in /app/mysqlrouter
* Healtcheck is disabled by default, it can be enabled if necessary (see docker-compose.yml.healtcheck)
* MySQL Router doesn't wait for all cluster members to be up

## Environment variables

This container accept this environment variables:

| Variable   | Required | Description |
| ------- | -------- | ----------- |
| `MYSQL_HOST` | `yes` |  master node |
| `MYSQL_PORT` | `yes` |  mysql port |
| `MYSQL_USER` | `yes` |  mysql user with necessary grants |
| `MYSQL_PASSWORD` | `yes` |  password of MYSQL_USER |
| `MYSQL_HC_USER` | `no` |  mysql healtcheck user with necessary grants (optional) |
| `MYSQL_HC_PASWORD` | `no` |  mysql healtcheck user password (optional)
| `MYSQL_ROUTER_ACCOUNT` | `no` |  mysql user created when mysqlrouter run a bootstrap |
| `MYSQL_ROUTER_PASSWORD` | `no` |  password of MYSQL_ROUTER_ACCOUNT |