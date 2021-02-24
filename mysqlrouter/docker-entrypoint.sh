#!/bin/bash
# Copyright (c) 2018, Oracle and/or its affiliates. All rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
set -e

BASE_PATH=/app/mysqlrouter

if [ "$1" = 'mysqlrouter' ]; then
    if [[ -z $MYSQL_HOST || -z $MYSQL_PORT || -z $MYSQL_USER || -z $MYSQL_PASSWORD ]]; then
	    echo "We require all of"
	    echo "    MYSQL_HOST"
	    echo "    MYSQL_PORT"
	    echo "    MYSQL_USER"
	    echo "    MYSQL_PASSWORD"
	    echo "to be set. Exiting."
	    exit 1
    fi

    PASSFILE=$(mktemp)
    echo "$MYSQL_PASSWORD" > "$PASSFILE"
    DEFAULTS_EXTRA_FILE=$(mktemp)
    cat >"$DEFAULTS_EXTRA_FILE" <<EOF
[client]
password="$MYSQL_PASSWORD"
EOF
    unset MYSQL_PASSWORD
    until mysql --defaults-extra-file="$DEFAULTS_EXTRA_FILE" -h "$MYSQL_HOST" -P"$MYSQL_PORT" -u "$MYSQL_USER" -nsLNE -e 'exit'; do
	  >&2 echo "MySQL is unavailable - sleeping"
	  sleep 5
    done

    echo "Succesfully contacted mysql server at $MYSQL_HOST. Checking for cluster state."
    if ! [[ "$(mysql --defaults-extra-file="$DEFAULTS_EXTRA_FILE" -u "$MYSQL_USER" -h "$MYSQL_HOST" -P "$MYSQL_PORT" -e "show status;" 2> /dev/null)" ]]; then
	    echo "Can not connect to database. Exiting."
	    exit 1
    fi

    echo "Check if config exist"
    if [ -f "$BASE_PATH/mysqlrouter.key" ]; then
       echo "Config found."
       echo "Start mysqlrouter"
       exec "$@" --config $BASE_PATH/mysqlrouter.conf
    else 
        echo "Succesfully contacted mysql server at $MYSQL_HOST. Trying to bootstrap."
        mysqlrouter --bootstrap "$MYSQL_USER@$MYSQL_HOST:$MYSQL_PORT" --user=mysqlrouter --directory $BASE_PATH --force < "$PASSFILE"
        sed -i -e 's/logging_folder=.*$/logging_folder=/' $BASE_PATH/mysqlrouter.conf
        echo "Starting mysql-router."
        exec "$@" --config $BASE_PATH/mysqlrouter.conf
    fi
fi

rm -f "$PASSFILE"
rm -f "$DEFAULTS_EXTRA_FILE"
unset DEFAULTS_EXTRA_FILE

exec "$@"
