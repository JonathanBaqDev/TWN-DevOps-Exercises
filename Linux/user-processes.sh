#!/bin/bash

check_processes(){
	local sort=$1
	local metric=$2
	
	if [[ "$sort" ]]
	then
		ps aux --sort="$sort" | { head -n 1; grep "$USER"; }
		echo "Processes sorted by "$metric" consumption"
	else
		ps aux | { head -n 1; grep "$USER"; }
	fi
}

echo "Processes for $USER: "
check_processes

read -p "Enter 1 to sort by memory or 2 by CPU consumption: " sort_input

if [[ "$sort_input" != "1" && "$sort_input" != "2" ]] 
then
	echo "Error: Input is not 1 or 2."
	exit 1
else
	if [[ "$sort_input" == "1" ]]
	then
		check_processes	"%mem" "memory"
	else
		check_processes "%cpu" "CPU"
	fi
fi
