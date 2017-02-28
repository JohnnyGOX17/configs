#!/bin/sh
# 
# Shell script to install all needed development tools, base environment
# settings, and config files. After install, any updates to config files or
# other variables in repo can be integrated with the UPDATE_DEV_ENV.sh script
# AUTHOR: John Gentile
#

# start by making sure base system is up-to-date
yum update -y

# install Groups from CentOS 7 repo
yum group install -y "Development Tools" "Compatibility Libraries" "Console Internet Tools" "Security Tools" "System Administration Tools"

# make sure we have all files from configs-tools repo
git clone https://github.com/JohnnyGOX17/configs.git ~/

# git completion
wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
mkdir ~/scripts
mv git-completion.bash ~/scripts

# install wget to easily get files from online
yum install -y wget

# install i3 repo and install minimal X11 setup with i3 window manager
# https://copr.fedorainfracloud.org/coprs/admiralnemo/i3wm-el7/
wget -O /etc/yum.repos.d/admiralnemo-i3wm-el7.repo https://copr.fedorainfracloud.org/coprs/admiralnemo/i3wm-el7/repo/epel-7/admiralnemo-i3wm-el7-epel-7.repo
# Install X11 server and drivers (e.g. for VMware virtual machine)
yum install -y xorg-x11-server-Xorg xorg-x11-drv-vmware xorg-x11-drv-vmmouse xorg-x11-drv-evdev mesa-dri-drivers
yum install -y lightdm xorg-x11-xinit-session
yum install -y dejavu-sans-fonts dejavu-sans-mono-fonts dejavu-serif-fonts i3 i3status lilyterm
yum install -y py3status feh
# set to boot to GUI by default
systemctl set-default graphical.target

# fetch and install ranger, then delete DL'ed files
# http://ranger.nongnu.org/download.html
wget http://nongnu.org/ranger/ranger-stable.tar.gz
tar xvf ranger-stable.tar.gz
rm ranger-stable.tar.gz
cd ranger-stable
make install
cd ..
rm -r ranger-stable


