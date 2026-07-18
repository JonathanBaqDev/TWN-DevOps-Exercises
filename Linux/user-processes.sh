#!/bin/bash

check_processes(){
	local sort_input=$1
	local sort="none"
	local limit_input=$2
	local metric="none"

	local ps_cmd="ps aux"
	local filter_cmd="cat"
	local msg="Script complete."


	if ! [[ "$limit_input" =~ ^[0-9]+$ ]] || [ "$limit_input" -le 0 ]; 
	then
		echo "Limit is invalid, no limit applied."
	else
		filter_cmd="head -n $((limit_input + 1))"
		msg+=" Results limited to "$limit_input"."	
	fi	

	if [[ "$sort_input" != "1" && "$sort_input" != "2" ]]; 
	then
		echo "Input is not 1 or 2, no sorting applied."
	else
		if [[ "$sort_input" == "1" ]];
		then
			sort="memory"
			metric="-pmem"
		else
			sort="CPU"
			metric="-pcpu"
		fi

		ps_cmd="ps aux --sort="$metric""
		msg+=" Results sorted by "$sort"."	
	fi
	
	$ps_cmd | { head -n1; grep "^$USER"; } | eval "$filter_cmd"	
	echo "$msg"
}

read -p "Enter 1 to sort by memory or 2 by CPU consumption: " sort_input
read -p "Enter the number of processes to show (number greater than 0): " limit_input 

check_processes "$sort_input" "$limit_input"
