# zabbix-sensors-lld
Send sensors output to Zabbix by low level discovery feature.

## how-to
* install **lm-sensors** package
* run **sensors-detect** after installation
* put **userparameter_sensors.conf** to /etc/zabbix/zabbix_agentd.d/ or set path in your zabbix_agentd.conf file
* put **hardware_sensors.sh** to some folder: e.g. /opt/zabbix, make executable for zabbix user
* apply template
