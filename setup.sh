#!/bin/bash    


# Text colors
RED='\033[0;31m'
RESET_COLOR='\033[0m' # No Color
GREEN='\033[0;32m'
BLUE='\033[0;34m'
# Text background colors 
BACK_Green='\033[42m'
BACK_Blue='\033[44m'
BACK_Yellow='\033[43m'
RESET_BACK_COLOR='\033[m' # Reset Background color
BACK_MAGENTA='\033[35m'

# TODO add JAVA installer , think about phpstorm,clion
YANDEXDISK='http://repo.yandex.ru/yandex-disk/yandex-disk_latest_amd64.deb'

# github info
GITHUB_NAME='ashe23'
GITHUB_EMAIL='ashot7410@gmail.com'

# Projects folder config
PROJECTS_ROOT_DIR='Projects'

# Downloadable programs
SKYPE_ALPHA_URL='https://www.skype.com/en/download-skype/skype-for-linux/downloading-web/?type=weblinux-deb'
  
checkForRoot() {
	if [ "$(id -u)" != "0" ]; then
	   echo "${RED}This script must be run as root ${RESET_COLOR}" 1>&2
	   exit 1
	fi
}

createAliasFileAndAddProjectDir() {
	cd $HOME
	mkdir -p $PROJECTS_ROOT_DIR
	# checks if .bash_aliases file exists
	if [ -f $HOME/.bash_aliases ]; then
    	echo "${RED}File  .bash_aliases already exists! Do you want to replace it? (y/N)${RESET_COLOR}"
    	read replaceFile
    	if [ "$replaceFile" = 'y' ] || [ "$replaceFile" = 'Y' ]; then
			echo 'alias desk="cd $HOME/Desktop"
alias sysupd="sudo apt-get update"
alias sysupg="sudo apt-get upgrade"
alias yd="cd $HOME/Yandex.Disk"
alias dow="cd $HOME/Downloads"
alias projects="cd $HOME/'$PROJECTS_ROOT_DIR'"' > .bash_aliases		
		else
			echo 'skipping...'
		fi
	fi
}

show_OScomponents() {
	echo "${BACK_MAGENTA}OS components${RESET_BACK_COLOR}\n"
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
	echo "${BACK_MAGENTA}WEB components${RESET_BACK_COLOR}\n"
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

bIsInstalled() {
	local result=1	
	command -v ${1} >/dev/null 2>&1 || { 
		local result=0;		
	}	
	if [ $result -eq 1 ]; then
		return 1;
	else
		return 0;
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

install_OpenGL() {
    apt-get install freeglut3 freeglut3-dev
    apt-get install binutils-gold
    # need this libs for ubuntu
    apt-get install libxmu-dev libxi-dev
}

install_MC() {
	apt-get install mc
}

install_Git() {
	apt install git
	# filemode change ignore
	git config --global core.filemode false
	# default credentials
	git config --global user.name $GITHUB_NAME
	git config --global user.email $GITHUB_EMAIL
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
	apt install vlc

}

install_YOUTUBEDL() {
	add-apt-repository ppa:nilarimogard/webupd8
	apt-get install youtube-dl
}

install_Archivators () {
	sudo apt install p7zip-full p7zip-rar
	# do it right extraction
	# link: https://brettcsmith.org/2007/dtrx/
	sudo apt install dtrx
}

install_OKULAR () {
	bIsInstalled okular
	return_val=$?
	if [ "$return_val" -eq "0" ];then
		apt install okular
	fi
}

installEssentialPrograms() {
	#apt update
	#createAliasFileAndAddProjectDir
	#install_MC
	#install_Git
	#install_Sublime3
	#install_VLCplayer
	#install_Archivators
	install_OKULAR
	# okular
	# gwenview
	# sublime
	# skype
	# cherryTree
	# KeePassX
	# VLC
	# ThunderBird
	# 7zip,dtrx
	# Gimp
	# Libre Office
	# Meld diff
	# Joxy
	# Git
	# Yandex Disk
	# xmind
	#apt upgrade
}

installOScomponents() {
	apt-get update
	createAliasFileAndAddProjectDir
	install_OpenGL
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

#showing which programs are installed and which are not
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
		installEssentialPrograms
		#installOScomponents
		#installWEBcomponents
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



