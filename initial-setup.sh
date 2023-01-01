#!/bin/bash

# Fix locales
sudo sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
echo -ne 'LANG="en_US.UTF-8"\nLC_CTYPE="en_US.UTF-8"\nLC_MESSAGES="en_US.UTF-8"\nLC_ALL="en_US.UTF-8"' >> /etc/default/locale
sudo dpkg-reconfigure --frontend=noninteractive locales

