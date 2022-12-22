#!/bin/bash

AWS_NTP_SERVER="/etc/systemd/timesyncd.conf"

NTP_SERVER="$(cat /etc/systemd/timeconf.d 2>/dev/null | grep 169.254.169.123)"

if [ -z "$NTP_SERVER" ]
then
  echo "NTP server is not set, setting it to AWS NTP Server"
  echo "server 169.254.169.123 prefer iburst" >> /etc/chrony/chrony.conf
  service chrony force-reload
fi
