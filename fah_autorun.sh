#!/bin/bash

echo $f_user > ~/on-start_variables.log
echo $f_team >> ~/on-start_variables.log
echo $f_passkey >> ~/on-start_variables.log
echo $f_power >> ~/on-start_variables.log
echo $f_clientType >> ~/on-start_variables.log

# this is for the initial sample config.xml, before fahclient cleans it up
xmlstarlet ed -L -u "/config/user/@value" -v $f_user /etc/fahclient/config.xml
xmlstarlet ed -L -u "/config/team/@value" -v $f_team /etc/fahclient/config.xml
xmlstarlet ed -L -u "/config/passkey/@value" -v $f_passkey /etc/fahclient/config.xml
xmlstarlet ed -L -u "/config/power/@value" -v $f_power /etc/fahclient/config.xml
xmlstarlet ed -L -u "/config/gpu/@value" -v true /etc/fahclient/config.xml

# in case fahclient has already cleaned up the config.xml
xmlstarlet ed -L -u "/config/user/@v" -v $f_user /etc/fahclient/config.xml
xmlstarlet ed -L -u "/config/team/@v" -v $f_team /etc/fahclient/config.xml
xmlstarlet ed -L -u "/config/passkey/@v" -v $f_passkey /etc/fahclient/config.xml
xmlstarlet ed -L -u "/config/power/@v" -v $f_power /etc/fahclient/config.xml
xmlstarlet ed -L -u "/config/gpu/@v" -v true /etc/fahclient/config.xml

/etc/init.d/FAHClient start
#sleep 1
#if [ $f_clientType = advanced ]; then
#  echo "detected client-type=advanced" >> ~/on-start_variables.log
#  /usr/bin/FAHClient --send-command 'options client-type=advanced'
#  /usr/bin/FAHClient --send-command save
#  /etc/init.d/FAHClient restart
#else
#  echo "client-type=advanced was not detected" >> ~/on-start_variables.log
#fi
