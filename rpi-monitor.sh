#!/bin/bash

RED=27
YELLOW=17
GREEN=4
BUTTON=11

# disable HDMI
/usr/bin/tvservice -o > /dev/null

# disable triggers for RPI Zero LED
echo "none" > /sys/class/leds/led0/trigger

# set up PiBrella
echo "$RED" > /sys/class/gpio/export
echo "out" > /sys/class/gpio/gpio${RED}/direction
echo "0" > /sys/class/gpio/gpio${RED}/value
echo "$YELLOW" > /sys/class/gpio/export
echo "out" > /sys/class/gpio/gpio${YELLOW}/direction
echo "0" > /sys/class/gpio/gpio${YELLOW}/value
echo "$GREEN" > /sys/class/gpio/export
echo "out" > /sys/class/gpio/gpio${GREEN}/direction
echo "0" > /sys/class/gpio/gpio${GREEN}/value
echo "$BUTTON" > /sys/class/gpio/export
echo "in" > /sys/class/gpio/gpio${BUTTON}/direction

# loop to check for USB and WLAN connections
while :
do
    # turn LED ON (reverse) if no usb0 interface
    if (ifconfig usb0 | grep -q -E "inet\s([0-9]{1,3}\.){3}[0-9]{1,3}");
    then
        echo "1" > /sys/class/gpio/gpio${GREEN}/value
    else
        echo "0" > /sys/class/gpio/gpio${GREEN}/value
        echo "0" > /sys/class/leds/led0/brightness
    fi
    sleep 0.5
    
    # turn LED ON (reverse) if no wlan0 interface
    if (ifconfig wlan0 | grep -q -E "inet\s([0-9]{1,3}\.){3}[0-9]{1,3}");
    then
        echo "1" > /sys/class/gpio/gpio${YELLOW}/value
    else
        echo "0" > /sys/class/gpio/gpio${YELLOW}/value
        echo "0" > /sys/class/leds/led0/brightness
    fi
    sleep 0.5

    # always turn LED OFF at the end
    echo "1" > /sys/class/leds/led0/brightness
    sleep 0.5

    if [ `cat /sys/class/gpio/gpio${BUTTON}/value` -eq 1 ]
    then
        echo "0" > /sys/class/gpio/gpio${GREEN}/value
        echo "0" > /sys/class/gpio/gpio${YELLOW}/value
        sudo shutdown -h now
    fi
done
