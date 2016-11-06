#!/usr/bin/env bash
#
# Copyright 2016 Petro Matviichuk
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

SUNIT=$1

if [ $# -eq 0 ]; then
  exit 1
fi

#Run sensors and check if something received
function GetSensors(){
 SDATA=$(sensors 2>&1)

 if [[ "$SDATA" = *"No sensors found!"* ]]; then
  exit 1
 fi
}

function CreateZabbixData() {
 #Run sensors command and get data depending on sensors values
 local SNAME=($(grep ".$1" <<< "$SDATA" | awk -F".$1" '{print $1}' | awk -F: '{print $1}' | tr  ' ' -))
 local SVALUE=($(grep ".$1" <<< "$SDATA" | awk -F".$1" '{print $1}' | awk -F: '{print $2}' | tr -d ' '))

 #Create JSON object for Zabbix
 echo "{"
 echo "\"data\":["

 local comma=""
 for ((i=0;i<${#SNAME[@]};i++))
 do
  IFS='-' #Handle sensor name with spaces
  echo "  $comma{\"{#SNAME}\":\""${SNAME[$i]}"\",\"{#SVALUE}\":\"${SVALUE[$i]}\"}";
  local comma=","
 done
 unset IFS
 echo "]"
 echo "}"
}

#main part
GetSensors
if [[ "$SUNIT" = "volts" ]]; then CreateZabbixData "V "
 elif [[ "$SUNIT" = "temp" ]]; then CreateZabbixData "C "
 elif [[ "$SUNIT" = "fan" ]]; then CreateZabbixData "RPM "
 else grep "$SUNIT" <<< "$SDATA" | awk -F: '{print $2}' | awk '{print $1}' | grep -Eo '[0-9\.]+?'
fi
