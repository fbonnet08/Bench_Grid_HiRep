#!/bin/bash

_f100=15
CNT=0

ProgressBar (){
    sp='/-\|'
    printf '\b%.1s' "$sp"
    _percent=$(awk -vp=$1 -vq=$_f100 'BEGIN{printf "%0.2f", p*100/q*100/100}')
    _progress=$(awk -vp=$_percent 'BEGIN{printf "%i", p*4/10}')
    _remainder=$(awk -vp=$_progress 'BEGIN{printf "%i", 40-p}')
    _completed=$(printf "%${_progress}s" )
    _left=$(printf "%${_remainder}s"  )
    printf "\rProgress : [$_completed#$_left-] ${_percent}%%"
    sp=${sp#?}${sp%???}
}

sp='/-\|'
sampling_freq_in=1
while [ "${CNT}" -lt  "${_f100}" ]
do

    CNT=$(awk -vp=$CNT -vq=$sampling_freq_in 'BEGIN{printf "%i", p + q}')
    ProgressBar "${CNT}"
    sleep 1
done
printf "\n"


sp='/-\|'
printf ' '
while true; do
    printf '\b%.1s' "$sp"
    sp=${sp#?}${sp%???}
done

