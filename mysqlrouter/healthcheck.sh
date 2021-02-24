#!/bin/bash
HOSTNAME=$(hostname)
if [[ -z $MYSQL_HC_USER || -z $MYSQL_HC_PASSWORD ]]; then
        echo "We require all of"
        echo "    MYSQL_HC_USER"
        echo "    MYSQL_HC_PASSWORD"
        echo "to be set. Exiting."
        exit 1
fi

mysql -h $HOSTNAME --port=6447 --user="$MYSQL_HC_USER" --password="$MYSQL_HC_PASSWORD" -e 'SELECT 1;'
