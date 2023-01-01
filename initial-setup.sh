#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;32m'
NC='\033[0m' # No Color

# -------------------------------- HELPER FUNCTIONS -------------------------------- #

prompt_yn() {
  tput setaf 5
  echo
  input=""
  while [ "$input" != "y" ] && [ "$input" != "n" ]; do
    read -p "$1 (y/n): " input
  done
  tput sgr0
  echo
  if [ "$input" == "y" ]; then
    return 1
  else
    return 0
  fi
}

configure_locales() {
  sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
  echo -ne 'LANG="en_US.UTF-8"\nLC_CTYPE="en_US.UTF-8"\nLC_MESSAGES="en_US.UTF-8"\nLC_ALL="en_US.UTF-8"' >> /etc/default/locale
  dpkg-reconfigure --frontend=noninteractive locales
}

# ---------------------------------- SCRIPT LOGIC ---------------------------------- #

# Exit if user isn't root.
user_id=$(id -u)
if [ $user_id -ne 0 ]; then
  printf "${RED}Script should be run as root!${NC}\n"
  exit
fi

apt-get update && apt-get upgrade -y

prompt_yn "Do you want to configure locales?"
result=$?
if [ $result -eq 1 ]; then
  echo "+ Configuring locales - setting language as 'en_US.UTF-8'"
  configure_locales
else
  echo "x Skipping locales configuration"
fi

