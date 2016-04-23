#!/bin/bash    

YANDEXDISK='http://repo.yandex.ru/yandex-disk/yandex-disk_latest_amd64.deb'
#Text colors
RED='\033[0;31m'
RESET_COLOR='\033[0m' # No Color
GREEN='\033[0;32m'
BLUE='\033[0;34m'
#Text background colors 
BACK_Green='\033[42m'
BACK_Blue='\033[44m'
BACK_Yellow='\033[43m'
RESET_BACK_COLOR='\033[m' # Reset Background color
  
checkForRoot() {
	if [ "$(id -u)" != "0" ]; then
	   echo "${RED}This script must be run as root${RESET}" 1>&2
	   exit 1
	fi
}

createAliasFile() {
	#TODO if alias file exits change it? replace ? or delete and add new one?
	cd $HOME
	touch .bash_aliases
cat <<ALIASES >> .bash_aliases
alias desk="cd $HOME/Desktop "
alias sysupd="sudo apt-get update"
alias sysupg="sudo apt-get upgrade"
alias yd="cd $HOME/Yandex.Disk"
ALIASES
}

show_OScomponents() {
	echo "${BACK_Yellow}OS components${RESET_BACK_COLOR}\n"
	isProgInstalled mc
	isProgInstalled git
	isProgInstalled curl
	isProgInstalled htop
	isProgInstalled top
	isProgInstalled subl	
	isProgInstalled google-chrome-stable
	isProgInstalled skype		
	isProgInstalled yandex-disk		
	isProgInstalled gimp		
	isProgInstalled cherrytree
	isProgInstalled youtube-dl		
	isProgInstalled vlc		
}

show_WEBcomponents() {
	echo "${BACK_Yellow}WEB components${RESET_BACK_COLOR}\n"
	isProgInstalled composer	
	isProgInstalled bower
	isProgInstalled phpunit
	isProgInstalled symfony
	isProgInstalled apache2
	isProgInstalled mysql
	isProgInstalled php
	isProgInstalled nodejs
	isProgInstalled npm
	isProgInstalled modernizr

}

isProgInstalled() {	
	local result=1	
	command -v ${1} >/dev/null 2>&1 || { 
		local result=0;		
	}	
	if [ $result -eq 1 ]; then
		echo >&2 "${GREEN}✔ '${1}' installed.${RESET_COLOR}"; 
	else
		echo >&2 "${RED}✘ '${1}' not installed.${RESET_COLOR}"; 		
	fi	
}

install_LAMP() {
	apt-get install apache2
	apt-get install mysql-server
	apt-get install php libapache2-mod-php php-mcrypt php-mysql
}


install_YandexDisk() {
	wget -P $HOME $YANDEXDISK
	cd $HOME
	dpkg -i yandex-disk_latest_amd64.deb	
}

install_MC() {
	apt-get install mc
}

install_Git() {
	apt-get install git
	# filemode change ignore
	git config --global core.filemode false
}

install_HTOP() {
	apt-get install htop
}

install_Chrome() {
	wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
	sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
	apt-get install google-chrome-stable
}

install_Skype(){
	# Users of 64-bit Ubuntu, should enable MultiArch
	# if it isn't already enabled by running the command 
	dpkg --add-architecture i386
	add-apt-repository "deb http://archive.canonical.com/ $(lsb_release -sc) partner"
	apt-get install skype
}

install_Gimp() {
	add-apt-repository ppa:otto-kesselgulasch/gimp
	apt-get install gimp
}

install_Sublime3() {
	add-apt-repository ppa:webupd8team/sublime-text-3
	apt-get install sublime-text-installer
}

install_Composer() {
	curl -sS https://getcomposer.org/installer | php
	mv composer.phar /usr/local/bin/composer
}

install_Symfony() {
	curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony
	chmod a+x /usr/local/bin/symfony
}

install_PHPUnit() {
	wget https://phar.phpunit.de/phpunit.phar
	chmod +x phpunit.phar
	mv phpunit.phar /usr/local/bin/phpunit
}

install_NODEJS() {
	curl -sL https://deb.nodesource.com/setup | sudo bash -
	apt-get install nodejs
	apt-get install build-essential
	apt-get install npm
}


install_NodePackages() {
	npm install -g bower
	npm install -g modernizr
}

install_CherryTree() {
	add-apt-repository ppa:vincent-c/cherrytree
	apt-get install cherrytree
}

install_VLCplayer() {
	add-apt-repository ppa:videolan/stable-daily
	apt-get install vlc

}

install_YOUTUBEDL() {
	add-apt-repository ppa:nilarimogard/webupd8
	apt-get install youtube-dl
}

installOScomponents() {
	apt-get update
	createAliasFile
	install_MC
	install_Git
	install_HTOP
	install_Chrome
	install_Skype
	install_Gimp
	install_Sublime3
	install_CherryTree
	install_YOUTUBEDL
	install_YandexDisk
	apt-get upgrade
}

installWEBcomponents() {
	apt-get update
	install_LAMP
	install_Composer
	install_NODEJS
	install_Symfony
	install_PHPUnit
	install_NodePackages
	apt-get upgrade
}


checkForRoot

# if -i flag used we just showing information about programs
if [ "$1" = "-i" ]; then
	echo '\n'
	show_OScomponents
	echo '\n'
	show_WEBcomponents
	echo '\n'
	exit 1;
fi

#showing which programs are installed and whic are not
echo '\n'
	show_OScomponents
	echo '\n'
	show_WEBcomponents
	echo '\n'
echo "${BLUE}Do you want to install missing programs?(y/N):${RESET_COLOR}"

#ask user to install missing programs
read question
if [ "$question" = "y" ] || [ "$question" = "Y" ]; then
	echo "${BLUE}Both WEB and OS componets?(y - both, 1 - only OS , 2 - only WEB):${RESET_COLOR}"
	read component
	if [ -z "$component" ]; then
		echo "Aborting."
		exit 1;
	elif [ "$component" = "y" ] || [ "$component" = "Y" ]; then
		echo "installing both..."
		installOScomponents
		installWEBcomponents
		show_OScomponents
		echo '\n'
		show_WEBcomponents
		echo '\n'
	elif [ "$component" -eq "1" ]; then
		echo "installing OS..."
		installOScomponents
		echo '\n'
		show_OScomponents	
		echo '\n'
	elif [ "$component" -eq "2" ]; then
		echo "installing WEB..."
		installWEBcomponents
		echo '\n'
		show_WEBcomponents	
		echo '\n'		
	fi			
else
	echo "Aborting."
	exit 1;
fi



