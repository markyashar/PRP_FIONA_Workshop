# This repository includes the Jupyter Notebooks used in in the Pacific Research Platform (PRP) FIONA Workshop, March 3-4 2018 at the Hyatt Regency in Monterey, CA

# Also included here is the script PRP Collect_Info v0.1 (collect_info.sh)

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

# The script PRP Collect_Info CSV v0.2 (collect_info_csv.sh)
# Written by Josh Sonstroem on 22 June 2016 for the NSF PRP
# This version outputs to CSV (single line) format

# Same as the collect_info.sh script except this script outputs
# into a Google Doc style single-line CSV format which can be imported
# directly into a google doc using the import tool from the file menu.

# As root, invoke the script with a space separated list of all your NIC
# names as arguments and redirect output into a file, e.g., 

# sudo sh collect_info_csv.sh doceker0 enp3s0 enp4s0 lo wlp2s0 > collect_info_out.csv

