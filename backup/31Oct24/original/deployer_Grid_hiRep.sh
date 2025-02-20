#!/usr/bin/bash
#colors
red="tput setaf 1"  ;green="tput setaf 2"  ;yellow="tput setaf 3"
blue="tput setaf 4" ;magenta="tput setaf 5";cyan="tput setaf 6"
white="tput setaf 7";bold=""               ;reset_colors="tput sgr0"
# Global variables
sptr="/"
# read username and echo username in terminal
#echo           "Enter Username         : "; username="frederic"                    # read username;
#echo           "Enter remote hostname  : "; remote_hostname="137.44.5.215" # read remote_hostname;

#echo           "Enter Username         : "; username="dc-bonn2"                    # read username;
#echo           "Enter remote hostname  : "; remote_hostname="tursa.dirac.ed.ac.uk" # read remote_hostname;

echo           "Enter Username         : "; username="eufredericb"                  # read username;
echo           "Enter remote hostname  : "; remote_hostname="login.vega.izum.si"    # read remote_hostname;

echo
$white; printf "username               : ";$green;  printf "$username\n";$reset_colors;
$white; printf "remote hostname        : ";$yellow; printf "$remote_hostname\n";$reset_colors;

user_remote_host=${username}"@"${remote_hostname}
$white; printf "user@hostname          : ";$blue;   printf "$user_remote_host\n";$reset_colors;
printf "\n"
# Getting the remote home dir from the remote (brutal way of doing this)
user_remote_home_dir=$(ssh -t ${user_remote_host} "cd ~/; pwd -P")
$white; printf "user remote home dir   : ";$magenta; printf "$user_remote_home_dir\n";$reset_colors;

# Setting the external lib_dir
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
lib_dir="SwanSea/SourceCodes/external_lib";
#external_lib_dir=$(echo $user_remote_home_dir$sptr$lib_dir | tr -d ' ')
chopped=$(echo "${user_remote_home_dir}" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
external_lib_dir=$chopped$sptr$lib_dir
$white; printf "external_lib_dir       : ";$yellow; printf "$external_lib_dir\n";$reset_colors;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"

ssh -t $user_remote_host "
#colors
red=\"tput setaf 1\"  ;green=\"tput setaf 2\"  ;yellow=\"tput setaf 3\"
blue=\"tput setaf 4\" ;magenta=\"tput setaf 5\";cyan=\"tput setaf 6\"
white=\"tput setaf 7\";bold=\"\"               ;reset_colors=\"\"
if [ -d ${external_lib_dir} ]
then
  \$white; printf \"Directory              : \"; \$bold;
  \$blue; printf \'%s\'\"${external_lib_dir}\"; \$green; printf \" exist, nothing to do.\n\"; \$white; \$reset_colors;
else
  \$white; printf \"Directory              : \"; \$bold;
  \$blue; printf \'%s\'\"${external_lib_dir}\"; \$red;printf \" does not exist, We will create it ...\n\"; \$white; \$reset_colors;
  mkdir -p ${external_lib_dir}
  printf \"                       : \"; \$bold;
  \$green; printf \"done.\n\"; \$reset_colors;
fi
cd ${external_lib_dir};
pwd
ls -al ${external_lib_dir}
"

scp -r ./dependencies_Grid.sh ./Scripts ${user_remote_host}:${external_lib_dir}

ssh -t $user_remote_host " cd ${external_lib_dir};
 ls -al; which bash ; bash -s < ./dependencies_Grid.sh SwanSea/SourceCodes/external_lib;"




