#!/bin/sh

default_timer_var=180
beep_count=3
no_mpc_bool="false"

post_time()
{
	min=0
	sec=0

	for i in $(seq 1 $TIMER_ENVVAR); do

		((++sec))
		((sec%60==0)) && ((++min)) && sec=0


		min_str=$min
		((min<10)) && min_str=0${min_str}
		
		sec_str=$sec
		((sec<10)) && sec_str=0${sec_str}
		
		clear
		printf -- "---------\n"
		printf -- "| %s:%s |\n" "$min_str" "$sec_str"
		printf -- "---------\n"
		sleep 1
	done
}

exec_timer()
{
	#sleep $TIMER_ENVVAR 
	post_time

	[ "X$no_mpc_bool" = "Xfalse" ] && mpc pause

	for i in $(seq 1 $beep_count); do
		printf '\a'
		sleep 1
	done

	[ "X$no_mpc_bool" = "Xfalse" ] && mpc play
}

[ -z "$TIMER_ENVVAR" ] && TIMER_ENVVAR="${1-$default_timer_var}"
[ "$2" = "--no-mpc" ] && no_mpc_bool="true"

exec_timer
