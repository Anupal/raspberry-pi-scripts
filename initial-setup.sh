#!/bin/bash

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
  echo "Script should be run as root!" >&2
  exit 1
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

# Install Docker
prompt_yn "Do you want to install Docker?"
result=$?
if [ $result -eq 1 ]; then
  echo "+ Installing Docker"
  curl -fsSL https://get.docker.com -o get-docker.sh
  sh get-docker.sh
  usermod -aG docker $SUDO_USER
else
  echo "x Skipping Docker installation"
fi

# Install Pihole, DoH and DHCP server as Docker clients
prompt_yn "Do you want to setup Pihole, Cloudflared and DHCP helper Docker containers?"
result=$?
if [ $result -eq 1 ]; then
  echo "+ Setup Pihole, Cloudflared, and DHCP server as Docker containers"
  docker compose -f docker-pihole-doh-dhcp/docker-compose.yaml up -d
 else
  echo "x Skipping Pihole setup"
fi

