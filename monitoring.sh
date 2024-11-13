#!/bin/bash

architecture=$(uname -a)
printf "#Architecture: ${architecture}\n"

physical_proc=$(cat /proc/cpuinfo | grep "physical id" | sort -u | wc -l)
printf "#CPU physical: ${physical_proc}\n"

virtual_proc=$(cat /proc/cpuinfo | grep "^processor" | wc -l)
printf "#vCPU: ${virtual_proc}\n"

total_ram=$(free -m | grep "Mem" | awk '{print $2}')
used_ram=$(free -m | grep "Mem" | awk '{print $3}')
percentage_of_use=$(free -m | grep "Mem" | awk '{printf "%.2f", $3/$2 * 100}')
printf "#Memory Usage: ${used_ram}/${total_ram}MB (${percentage_of_use}%%)\n"

total_disk=$(df -h / | grep -v "Filesystem" | awk '{print $2}')
used_disk=$(df -h / | grep -v "Filesystem" | awk '{print $3}')
percentage_of_use_disk=$(df -h / | grep -v "Filesystem" | awk '{print $5}')
printf "#Disk Usage: ${used_disk}/${total_disk} (${percentage_of_use_disk}%)\n"

cpu_load=$(awk '/^cpu / {print $2+$3+$4+$6+$7+$8}' /proc/stat)
cpu_idle=$(awk '/^cpu / {print $5}' /proc/stat)
cpu_percent=$(echo "scale=2; 100 * $cpu_load / ($cpu_load + $cpu_idle)" | bc)
printf "#CPU load: (%.2f)%%\n" "$cpu_percent"

last_boot=$(uptime -s)
printf "#Last boot: ${last_boot}\n"

if lsblk | grep -q "lvm"; then
	lvm="yes"
else
	lvm="no"
fi
printf "#LVM use: ${lvm}\n"

tcp=$(ss -t state established | tail -n +2 | wc -l)
printf "#Connexions TCP: ${tcp} ESTABLISHED\n"

user_log=$(who | wc -l)
printf "#User log: ${user_log}\n"

ip_v4=$(ip -4 addr show enp0s3 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
mac=$(ip link show enp0s3 | grep -oP '(?<=ether\s)[\da-f:]+')
printf "#Network: IP ${ip_v4} (${mac})\n"

nb_sudo=$(grep -c "COMMAND" /var/log/sudo/sudo.log)
printf "#Sudo: ${nb_sudo} cmd\n"
