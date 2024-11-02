#!/usr/bin/bash
scrfipt_file_name=$(basename "$0")

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

hostname=$(echo $HOSTNAME); echo $hostname


if [[ $hostname =~ "tursa" ]]; then
  echo "Found 'tursa' in string."
  machine="tursa"
fi

echo $hostname
echo $machine

rm -rf external_lib/ Bench_Grid_HiRep/ Grid-Main/Grid/build/ BKeeper/build/

cd ./Sombrero/SOMBRERO;
make clean;
cd ${script_dir}

echo `pwd`
#-------------------------------------------------------------------------------
#End of the script
echo
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$cyan; echo `date`; $blue;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "-                  $scrfipt_file_name Done.                          -"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
#exit
#-------------------------------------------------------------------------------

