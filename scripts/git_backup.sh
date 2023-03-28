#!/bin/bash

export $(grep -v '^#' /home/pi/.gh_token | xargs -0)

#####################################################################
### Please set the paths accordingly. In case you don't have all  ###
### the listed folders, just keep that line commented out.        ###
#####################################################################
### Path to your config folder you want to backup
config_folder=/home/pi/printer_data/config

#####################################################################
#####################################################################

#####################################################################
################ !!! DO NOT EDIT BELOW THIS LINE !!! ################
#####################################################################

push_config(){
  cd $config_folder
  echo Pushing updates
  git pull -v
  git add . -v
  current_date=$(date +"%Y-%m-%d %T")
  git commit -m "Backup triggered on $current_date" -m "$m1" -m "$m2" -m "$m3" -m "$m4"
  git push "git@github.com:d5aint/klipper_config.git"
}

push_config