#!/bin/sh
set -ex

if [ "${CIRCLE_BRANCH}" != "master" ]; then
  exit 0
fi

SECURITY_GROUP="sg-07697b0d2a359fab9"
IP=`curl -s ifconfig.me`

aws ec2 authorize-security-group-ingress --group-id ${SECURITY_GROUP} --protocol tcp --port 22 --cidr ${IP}/32

bundle exec cap production deploy

aws ec2 revoke-security-group-ingress --group-id ${SECURITY_GROUP} --protocol tcp --port 22 --cidr ${IP}/32