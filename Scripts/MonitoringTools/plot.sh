#!/bin/bash
ARGV=`basename -a $1 $2`
tput bold;
echo "! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !"
echo "!                                                                       !"
echo "!     Wrapper code to get the size of a directory or directories        !"
echo "!     ScanProject-FromSourceSleepX.sh                                   !"
echo "!     [Author]: Frederic Bonnet May 2022                                !"
echo "!     [usage]: sh plot.sh  {Input list}                                 !"
echo "!     [example]: sh plot.sh 0.16666667  (0.166667 *60=10sec)            !"
echo "!                 1 {Sampling frequency 1 full second, 0.1 10th of sec }!"
echo "!                                                                       !"
echo "! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !"
tput sgr0;
screen_time_in=$1       #Sleep time between sweeps
sampling_freq_in=$2

log_file="incrementalspeed.log"
if [ ! $sampling_freq_in = "" ]; then monit_time_secs=$(awk -vp=$screen_time_in -vq=60 -vl=$sampling_freq_in 'BEGIN{printf "%i", p * q}'); fi

#exit
#File management variables
sleep_time=1
date_color=6
hostname=`hostname`
#-------------------------------------------------------------------------------
gpu_count=$(lspci |grep NVIDIA|grep "\["|wc -l)
cpu_count=$(grep -c ^processor /proc/cpuinfo)
#-------------------------------------------------------------------------------
ProgressBar (){
    _percent=$(awk -vp=$1 -vq=$2 'BEGIN{printf "%0.2f", p*100/q*100/100}')
    _progress=$(awk -vp=$_percent 'BEGIN{printf "%i", p*4/10}')
    _remainder=$(awk -vp=$_progress 'BEGIN{printf "%i", 40-p}')
    _completed=$(printf "%${_progress}s" )
    _left=$(printf "%${_remainder}s"  )
    printf "\rProgress : [-$_completed#$_left-] ";tput setaf 4; tput bold; printf "[= ";
    tput sgr0; tput setaf 6; printf "$1";
    tput sgr0; tput setaf 4; tput bold;printf " <---> ";   
    tput sgr0; tput setaf 6; tput bold;printf "(secs)";
    tput sgr0; tput setaf 2; tput bold; printf " ${_percent}%%"
    tput setaf 4; tput bold; printf " =]"
    tput sgr0
}
#-------------------------------------------------------------------------------
tput setaf 2; tput bold;
echo "* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *"
tput setaf 1; printf "Input parameters intor : ";
tput setaf 6; printf "plot.sh \n"; tput setaf 2;
echo "* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *"
tput sgr0;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
              printf "Log file to examine    : ";tput bold;
tput setaf 4; printf "$log_file\n"; tput sgr0;
              printf "Number of GPU to monit : ";tput bold;
tput setaf 3; printf "$gpu_count\n"; tput sgr0;
              printf "Screening time (min)   : ";tput bold;
tput setaf 2; printf "$screen_time_in\n"; tput sgr0;
              printf "CPU count on system    : ";tput bold;
tput setaf 6; printf "$cpu_count\n"; tput sgr0;
              printf "Sampling frequency     : ";tput bold;
tput setaf 5; printf "$sampling_freq_in\n"; tput sgr0;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
tput sgr0;
              printf "Monitoring time (secs) : ";tput bold;
tput setaf 5; printf "$monit_time_secs\n"; tput sgr0;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"

#First clean up previous samplings
for igpu in $(seq 1 $gpu_count)
do
    if [ -f gpu"$igpu"_temp_indx.asc ]; then rm gpu"$igpu"_temp_indx.asc; fi
    if [ -f gpu"$igpu"_fans_indx.asc ]; then rm gpu"$igpu"_fans_indx.asc; fi
    if [ -f gpu"$igpu"_util_indx.asc ]; then rm gpu"$igpu"_util_indx.asc; fi
    if [ -f gpu"$igpu".asc ]          ; then rm gpu"$igpu".asc          ; fi
    if [ -f $log_file ]               ; then rm $log_file               ; fi
done
case $hostname in
    *"guigui"*)
	gpu_type="GigaByte GeForce RTX-2080Ti"
    ;;
    *"sandy"*)
	gpu_type="PNY GeForce RTX-2080Ti"
    ;;
    *"sparky"*)
	gpu_type="PNY GeForce RTX-2080Ti"
    ;;
    *"amira-X7D"*)
	gpu_type="PNY GeForce RTX-2080Ti"
    ;;
    *"necen-1"*)
	gpu_type="GigaByte GeForce RTX-3080"
    ;;
    *"necen-2"*)
	gpu_type="GigaByte GeForce RTX-3080 "
    ;;
    *""*)
	gpu_type="Unknonwn"
    ;;
esac
#starts the monitoring process for screen_time_in
if [ ! $monit_time_secs = "" ]
then
    tput sgr0;
    tput bold; tput setaf 4;
    printf "Monitoring ---> ";tput sgr0;
    COUNTER=0
    COUNTER_SAMPLE=0
    CNT=0
    ISTRUE=true
    symbol1="3"
    symbol2="4"
    symbol3="5"
    symbol4="6"
    while $ISTRUE;
    do
	CNT=$(awk -vp=$CNT -vq=$sampling_freq_in 'BEGIN{printf "%0.2f", p + q}') #`expr $CNT + $sampling_freq_in`
	tput setaf 2;
	ProgressBar "${CNT}" "${monit_time_secs}"
	tput sgr0;
	#Sampling the gpu buisiness... and putting in the background
	python3 incrementalspeed.py >> $log_file &
	wait
	if [ $gpu_count -eq 4 ]
	then
	    string_temp=$(tail -n 1 $log_file| sed "1q;d"|awk '{print $11,$12,$13,$14}')
	    string_fans=$(tail -n 1 $log_file| sed "1q;d"|awk '{print $19,$20,$21,$22}')
	    string_util=$(tail -n 1 $log_file| sed "1q;d"|awk '{print $24,$25,$26,$27}')
	    input_file_asc_temp_strg="--symbol $symbol1 gpu1_temp_indx.asc --symbol $symbol2 gpu2_temp_indx.asc --symbol $symbol3 gpu3_temp_indx.asc --symbol $symbol4 gpu4_temp_indx.asc"
	    input_file_asc_fans_strg="--symbol $symbol1 gpu1_fans_indx.asc --symbol $symbol2 gpu2_fans_indx.asc --symbol $symbol3 gpu3_fans_indx.asc --symbol $symbol4 gpu4_fans_indx.asc"
	    input_file_asc_util_strg="--symbol $symbol1 gpu1_util_indx.asc --symbol $symbol2 gpu2_util_indx.asc --symbol $symbol3 gpu3_util_indx.asc --symbol $symbol4 gpu4_util_indx.asc"
	elif [ $gpu_count -eq 3 ]
	then
	    string_temp=$(tail -n 1 $log_file| sed "1q;d"|awk '{print $11,$12,$13}')
	    string_fans=$(tail -n 1 $log_file| sed "1q;d"|awk '{print $18,$19,$20}')
	    string_util=$(tail -n 1 $log_file| sed "1q;d"|awk '{print $22,$23,$24}')
	    input_file_asc_temp_strg="--symbol $symbol1 gpu1_temp_indx.asc --symbol $symbol2 gpu2_temp_indx.asc --symbol $symbol3 gpu3_temp_indx.asc"
	    input_file_asc_fans_strg="--symbol $symbol1 gpu1_fans_indx.asc --symbol $symbol2 gpu2_fans_indx.asc --symbol $symbol3 gpu3_fans_indx.asc"
	    input_file_asc_util_strg="--symbol $symbol1 gpu1_util_indx.asc --symbol $symbol2 gpu2_util_indx.asc --symbol $symbol3 gpu3_util_indx.asc"
	elif [ $gpu_count -eq 2 ]
	then
	    string_temp=$(tail -n 1 $log_file| sed "1q;d"|awk '{print $11,$12}')
	    string_fans=$(tail -n 1 $log_file| sed "1q;d"|awk '{print $17,$18}')
	    string_util=$(tail -n 1 $log_file| sed "1q;d"|awk '{print $20,$21}')
	    input_file_asc_temp_strg="--symbol $symbol1 gpu1_temp_indx.asc --symbol $symbol2 gpu2_temp_indx.asc"
	    input_file_asc_fans_strg="--symbol $symbol1 gpu1_fans_indx.asc --symbol $symbol2 gpu2_fans_indx.asc"
	    input_file_asc_util_strg="--symbol $symbol1 gpu1_util_indx.asc --symbol $symbol2 gpu2_util_indx.asc"
	elif [ $gpu_count -eq 1 ]
	then
	    string_temp=$(tail -n 1 $log_file| sed "1q;d"|awk '{print $11}')
	    string_fans=$(tail -n 1 $log_file| sed "1q;d"|awk '{print $16}')
	    string_util=$(tail -n 1 $log_file| sed "1q;d"|awk '{print $18}')
	    input_file_asc_temp_strg="--symbol $symbol1 gpu1_temp_indx.asc"
	    input_file_asc_fans_strg="--symbol $symbol1 gpu1_fans_indx.asc"
	    input_file_asc_util_strg="--symbol $symbol1 gpu1_util_indx.asc"
	fi
	#echo $string_temp
	COUNTER_SAMPLE=$(expr $COUNTER_SAMPLE + 1)
	for igpu in $(seq 1 $gpu_count)
	do
	    chop_temp=$(echo $string_temp|sed 's/" "/\n/'|awk '{print $'$igpu'}')
	    chop_fans=$(echo $string_fans|sed 's/" "/\n/'|awk '{print $'$igpu'}')
	    chop_util=$(echo $string_util|sed 's/" "/\n/'|awk '{print $'$igpu'}')
	    msg_temp="$COUNTER_SAMPLE $chop_temp"
	    msg_fans="$COUNTER_SAMPLE $chop_fans"
	    msg_util="$COUNTER_SAMPLE $chop_util"
	    #file_out_temp="gpu${igpu}_temp_indx.asc"
	    echo $msg_temp >> gpu"$igpu"_temp_indx.asc
	    echo $msg_fans >> gpu"$igpu"_fans_indx.asc
	    echo $msg_util >> gpu"$igpu"_util_indx.asc
	done

	min_temp=30
	max_temp=100
	out_file_temp_strg="monito_gpu_temp_hrs.png"
	#-y $min_temp $max_temp
	graph -T PNG --bg-color black --frame-color white --line-mode 2 -C -y $min_temp $max_temp --y-label "Temperature [C]" --x-label "indx ($sampling_freq_in [secs])" --title-font-size 0.046 --title-font-name HersheySerif -L "[$hostname] $gpu_type $gpu_count X GPU" $input_file_asc_temp_strg > $out_file_temp_strg &
	wait

	min_fans=20
	max_fans=110
	out_file_fans_strg="monito_gpu_fans_hrs.png"
	#-y $min_fans $max_fans
	graph -T PNG --bg-color black --frame-color white --line-mode 2 -C -y $min_fans $max_fans --y-label "GPU Fan [%]" --x-label "indx ($sampling_freq_in [secs])" --title-font-size 0.046 --title-font-name HersheySerif -L "[$hostname] $gpu_type $gpu_count X GPU" $input_file_asc_fans_strg > $out_file_fans_strg &
	wait

	min_util=-10
	max_util=100
	out_file_util_strg="monito_gpu_util_hrs.png"
	#-y $min_util $max_util
	graph -T PNG --bg-color black --frame-color white --line-mode 2 -C -y $min_util $max_util --y-label "Volatile GPU-Utilization [%]" --x-label "indx ($sampling_freq_in [secs])" --title-font-size 0.046 --title-font-name HersheySerif -L "[$hostname] $gpu_type $gpu_count X GPU" $input_file_asc_util_strg > $out_file_util_strg &
	wait

	COUNTER=$(awk -vp=$CNT -vq=1.0 'BEGIN{printf "%i", p * q}') #`expr $CNT + $sampling_freq_in`
	[ "$((COUNTER))" -ge $monit_time_secs ] && break
	sleep $sampling_freq_in
    done
    #tput sgr0; tput setaf 5; tput bold
    #printf "(seconds) \n";tput sgr0
else
    tput sgr0;
    tput bold; tput setaf 4;
    printf "Monitoring ---> ";tput sgr0;
    tput bold; tput setaf 1; printf "Undefinetly TODO: here infinte while loop..."
    tput sgr0; tput setaf 5; tput bold
    printf "(seconds) \n";tput sgr0
fi
printf "\n";tput sgr0
    
#graph -T PNG --bg-color black --frame-color white --line-mode 2 -C -y $min_temp $max_temp --y-label "Temperature" --x-label "indx" --title-font-size 0.046 --title-font-name HersheySerif -L "PNY RTX-2080Ti $gpu_count GPU(s)" --symbol $symbol1 gpu1_temp_indx.asc --symbol $symbol2 gpu2_temp_indx.asc --symbol $symbol3 gpu3_temp_indx.asc --symbol $symbol4 gpu4_temp_indx.asc > monito_gpu_temp_"hrs.png"

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
#-------------------------------------------------------------------------------
tput sgr0;
tput setaf $date_color
echo `date` ; tput sgr0;
tput sgr0;
tput bold; tput setaf 4;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "-                 testing_Live_BlackFramesMeanInt.sh Done.              -"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
tput sgr0;
#-------------------------------------------------------------------------------
# [end] of testing_Live_BlackFramesMeanInt.sh bash script
#-------------------------------------------------------------------------------
