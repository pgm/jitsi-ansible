#!/bin/bash

DOMAINS=$1
EMAIL=$2

if [ "$DOMAINS" == "" -o "$EMAIL" == "" ] ; then
   echo "needs domains and email"
   exit -1
fi
  

if [ -e /etc/letsencrypt/live/${DOMAINS/,*/}/fullchain.pem ] ; then
    echo "Cert exists, exiting"
    exit 0
fi

if [ -e /etc/init.d/nginx ] ; then
    /etc/init.d/nginx stop
fi 

set -e
certbot certonly --standalone -d ${DOMAINS/,/ -d} --email=$EMAIL --agree-tos --non-interactive
set +e

if [ -e /etc/init.d/nginx ] ; then
    /etc/init.d/nginx start
fi 

