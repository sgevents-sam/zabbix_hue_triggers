#!/bin/bash

#Hue API needs to be activated on the bridge, with user available. Instructions on how to do this are available here:
#https://developers.meethue.com/develop/get-started-2/
# script should be located in /usr/lib/zabbix/alertscripts/
# To test, cd to the location above run the script with the 4 variables eg: ./hue.sh Disaster 192.168.1.245 UIHvYRW25jF72usGBEI99LqFSe3jepQZmtP1QUu6 1
# These below are the variables that would be passed in when you call the script - set these up as macros in the media type. 
# $1 should be the macro {ALERT.SUBJECT} to pull trigger severity
# $2 is the IP address of the hue bridge
# $3 is the API user of the hue bridge
# $4 is the number of the light or light group you wish to trigger. You will need to change the URL accordingly. 
# url for single light control is "http://${ip}/api/${user}/lights/${group}/state"
# url for group light contorl is "http://${ip}/api/${user}/groups/${group}/action"

subject=$1
ip=$2
user=$3
group=$4

# Construct the URL for the API from the variables.
url="http://${ip}/api/${user}/groups/${group}/action"

#set the lighting state to be called upon trigger below. 
resolved='{"on": true, "bri": 254, "hue": 25299, "sat": 254, "xy": [0.1761,0.6954], "alert": "none"}'
problem='{"on": true, "bri": 254, "hue": 11418, "sat": 254, "xy": [0.4589,0.483], "ct": 366, "alert": "lselect"}'
disaster='{"on": true, "bri": 254, "hue": 64927, "sat": 254, "xy": [0.6737,0.2997], "ct": 153, "alert": "lselect"}'
information='{"on": true, "bri": 254, "hue": 44073, "sat": 210, "xy": [0.1945,0.1806], "ct": 153, "alert": "lselect"}'
standby='{"on": true, "bri": 190, "hue": 8418, "sat": 140, "xy": [0.4573,0.41], "ct": 367, "alert": "none"}'
# Uncomment the next line to debug the URL that is constructed
#echo $url

# Work out which light statae should be called based on the variable called
# if the script was sent 'Disaster'...
    echo "Setting the light to...."
if [[ "$subject" = "Disaster" ]]; then
    curl -X PUT -H "Content-Type: application/json" -d "${disaster}" "${url}"
    echo "$subject"
# else if the script was sent 'High'...
elif [[ "$subject" = "High"* ]]; then
    curl -X PUT -H "Content-Type: application/json" -d "${disaster}" "${url}"
    echo "$subject"
# else if the script was sent 'Average'...
elif [[ "$subject" = "Average"* ]]; then
    curl -X PUT -H "Content-Type: application/json" -d "${problem}" "${url}"
    echo "$subject"
# else if the script was sent 'Warning'...
elif [[ "$subject" = "Warning"* ]]; then
    curl -X PUT -H "Content-Type: application/json" -d "${problem}" "${url}"
    echo "$subject"
# else if the script was sent 'Information'...
elif [[ "$subject" = "Information"* ]]; then
    curl -X PUT -H "Content-Type: application/json" -d "${information}" "${url}"
    echo "$subject"
# else if the script was sent 'Resolved'...
elif [[ "$subject" = "Resolved"* ]]; then
    curl -X PUT -H "Content-Type: application/json" -d "${resolved}" "${url}"
    sleep 20
    curl -X PUT -H "Content-Type: application/json" -d "${standby}" "${url}"
    echo "$subject"
fi

