#!/bin/sh
# FAT.app 
# Fix Apple TV version 2
# Created by: Marlon Arenas
# Date Created: 24 February 2016
# -------------------------------------------


# Detect OS Version 
osvers=`(sw_vers -productVersion | awk -F '.' '{print $2}')`


# Detect WI-FI Interface
device_id=`(networksetup -listnetworkserviceorder | awk '/Wi-Fi/{getline;print}' | awk -F 'Device: ' '{print $2}' | tr -d ')')`

# Turn of WIFI
networksetup -setairportpower $device_id off 
osascript -e 'display notification "Restarting AirPlay services, please wait..." with title "Fix Apple TV" sound name "Glass.aiff"' 


# pause for 5 secs for clear bonjour cache
sleep 5

if [ "$osvers" -eq 11 ] 
then
	sudo killall -HUP AirPlayXPCHelper
fi

if [ "$osvers" -eq 8 ]
then 
	# Kill Bonjour cache for MAVERICKS
	sudo dscacheutil -flushcache 
fi

#Flush Bonjour cache
sudo killall mDNSResponder

# Kill AirplayUI Agent
sudo killall -HUP AirPlayUIAgent

#Kill Core Audio Service
sudo killall coreaudiod 

#Put WIFI Interface back on
networksetup -setairportpower $device_id on  
osascript -e 'display notification "AirPlay Services has been restarted!" with title "Fix Apple TV" sound name "Glass.aiff"' 
exit 0
