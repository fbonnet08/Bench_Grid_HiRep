#!/bin/bash
compare() (IFS=" "
  exec awk "BEGIN{if (!($*)) exit(1)}"
)

sek=10.0
stop=0.0
echo "$sek Seconds"
COUNTER=0
while true
do
    COUNTER=`expr $COUNTER + 1`
    CNT=$(awk -vp=$sek -vq=$COUNTER 'BEGIN{printf "%0.2f", p - q}')
    printf "One moment please: %0.2f" "$CNT"
    sleep 1
    printf "\r%b" "\033[2K"
done
echo "Ready!"
