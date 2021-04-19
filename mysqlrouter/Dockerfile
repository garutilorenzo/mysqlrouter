FROM debian:buster-slim

RUN apt-get update && apt-get -y upgrade && apt-get install -y --no-install-recommends wget lsb-release gnupg hostname dirmngr && rm -rf /var/lib/apt/lists/* 
RUN mkdir ~/.gnupg && echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf

RUN set -ex; \
# gpg: key 5072E1F5: public key "MySQL Release Engineering <mysql-build@oss.oracle.com>" imported
	key='A4A9406876FCBD3C456770C88C718D3B5072E1F5'; \
	export GNUPGHOME="$(mktemp -d)"; \
	#gpg --batch --keyserver-options "timeout=10 http-proxy=$http_proxy" --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
	gpg --batch --keyserver-options "timeout=10" --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
	gpg --batch --export "$key" > /etc/apt/trusted.gpg.d/mysql.gpg; \
	gpgconf --kill all; \
	rm -rf "$GNUPGHOME"; \
	apt-key list > /dev/null

ENV MYSQL_MAJOR 8.0
ENV MYSQL_VERSION 8.0.23-1debian10

RUN echo "deb http://repo.mysql.com/apt/debian/ buster mysql-${MYSQL_MAJOR}" > /etc/apt/sources.list.d/mysql.list

# the "/var/lib/mysql" stuff here is because the mysql-server postinst doesn't have an explicit way to disable the mysql_install_db codepath besides having a database already "configured" (ie, stuff in /var/lib/mysql/mysql)
# also, we set debconf keys to make APT a little quieter
RUN { \
		echo mysql-community-server mysql-community-server/data-dir select ''; \
		echo mysql-community-server mysql-community-server/root-pass password ''; \
		echo mysql-community-server mysql-community-server/re-root-pass password ''; \
		echo mysql-community-server mysql-community-server/remove-test-db select false; \
	} | debconf-set-selections \
	&& apt-get update &&  DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true apt-get install -y mysql-client="${MYSQL_VERSION}"  mysql-community-client="${MYSQL_VERSION}"  && rm -rf /var/lib/apt/lists/*

RUN wget --no-check-certificate https://dev.mysql.com/get/mysql-apt-config_0.8.16-1_all.deb && dpkg -i mysql-apt-config_0.8.16-1_all.deb # Ref. https://dev.mysql.com/downloads/
RUN apt-get update && apt-get install -y --no-install-recommends mysql-router && rm -rf /var/lib/apt/lists/*

#ARG MYSQL_ROUTER_VERSION=8.0.18-1debian10_amd64
#RUN wget --no-check-certificate https://downloads.mysql.com/archives/get/p/41/file/mysql-router-community_${MYSQL_ROUTER_VERSION}.deb \
#    && dpkg -i mysql-router-community_${MYSQL_ROUTER_VERSION}.deb\
#    && rm -rf  mysql-router-community_${MYSQL_ROUTER_VERSION}.deb

RUN rm -rf /etc/mysqlrouter # cleanup 

# ARG UID=897
# ARG GID=897
# RUN groupadd -g ${GID} mysqlrouter 
# RUN useradd -u ${UID} -g ${GID} -m -d /app -s /bin/bash mysqlrouter
RUN usermod -d /app mysqlrouter
RUN mkdir -p /app/mysqlrouter/ && chown -R mysqlrouter:mysqlrouter /app

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh /entrypoint.sh # backwards compat
COPY healthcheck.sh /usr/local/bin/
RUN ln -s usr/local/bin/healthcheck.sh /healthcheck.sh

USER root
WORKDIR /app

EXPOSE 6446 64460 6447 64470

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["mysqlrouter"]
