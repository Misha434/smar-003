#!/bin/sh
set -ex

if [ "${CIRCLE_BRANCH}" != "master" ]; then
  exit 0
fi

# SECURITY_GROUP="sg-01c183b7eeba9b829"
SECURITY_GROUP="sg-07697b0d2a359fab9"
IP=`curl -s ifconfig.me`  # 現在起動しているコンテナのIPアドレスを代入

# コンテナのIPアドレスからのsshを許可
aws ec2 authorize-security-group-ingress --group-id ${SECURITY_GROUP} --protocol tcp --port 22 --cidr ${IP}/32
bundle exec cap production deploy  # ご存知デプロイコマンド
# 許可した設定をrevoke(取り消す)
aws ec2 revoke-security-group-ingress --group-id ${SECURITY_GROUP} --protocol tcp --port 22 --cidr ${IP}/32