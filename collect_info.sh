#! /bin/bash

# PRP Collect_Info v0.1
# Written by Josh Sonstroem on 21 June 2016 for the NSF PRP
# This version outputs in human readable format

# This script grabs system and network info related to 40 GE/100 GE
# tuning. It takes a list of NIC names as input. The script is intended
# as both a data collection tool and a "helping hand" for sysadmins who
# know the pleasure of managing 40 GE or 100 GE hosts (for example) in a
# multi-vendor, multi-NIC, multi-OS environment. The intended OS for this
# script is CentOS 6/7.

# The script takes a space separated list of NICs as input and outputs
# the results into a human readable format that is good for initial testing
# on a host. It may also be valuable in validaing that multiple hosts (or 
# multiple NICs on one host) have identical tuning.

# NOTE: The script will not modify any settings.

# As root, invoke the script with a space separated list of all your NIC names
# as arguments and redirect output into a file, e.g..

# sudo sh collect_info.sh docker0 enp3s0 enp4s0 wlp2s0 > collect_info_NICs_out.txt

args=0
count=0

echo "--> Server and OS"
uname -a
echo ""

echo "--> CPU Type"
lscpu
echo ""

echo "--> IRQ Balance?"
service irqbalance status
echo ""

echo "--> SYSCTL Settings?"
sysctl -a | egrep 'wmem|rmem|netdev_max_backlog|cong|timest|somaxconn' | egrep -v 'min|lowmem' 
echo ""

echo "--> RC.local?"
if [ -f /etc/rc.local ]; then
    cat /etc/rc.local | grep -v \#
fi
echo ""

echo "--> What test suites are running?"
netstat -anp | egrep '4823|5000|5001|5201' | awk '{print $7 " (" $4 ")" }' | cut -d/ -f2
echo ""

if [ "$#" -gt 0 ]; then
   for iface in "$@"; do
    count=$(expr $count + 1)
    echo "--> Interface $count: $iface"
    ifconfig $iface
    echo "Interface info for $iface:"
    ethtool -i $iface
    echo ""
    drv=$(ethtool -i $iface | grep driver | awk '{print $2}' | cut -d_ -f1)
    if [[ "$drv" == *"mlx"* ]]; then
        echo " * --> Detected a Mellanox at $iface!"
        echo ""
        echo "IRQ Affinity for $iface:"
        show_irq_affinity.sh $iface
        if [ "$args" -eq 1 ]; then
            mlnx_tune
        fi
    fi
    echo ""
    echo "Interrupts for $iface:"
    cat /proc/interrupts | head -1
    drvs=$(cat /proc/interrupts | egrep "$drv" | head -$count | tail -1)
    echo "$drvs"
    cat /proc/interrupts | egrep "$iface"
    echo ""
    ethtool -a $iface
    ethtool -c $iface
    ethtool -g $iface
    ethtool -k $iface | grep -v fixed
    echo ""
    ethtool --show-priv-flags $iface
    echo ""
    done
else
    echo "--> Choose from available interfaces?"
    ifconfig -a
    echo ""
    echo "Usage: ./collect_info.sh IF1 IF2 ... IFn"
fi
