#!/bin/bash

echo -e "\e[1mCount\tIP\e[0m"
zgrep -h "Ban " /var/log/fail2ban.log* | awk '{print $NF}' | sort | uniq -c
