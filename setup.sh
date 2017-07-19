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
	   echo "${RED}I cant see your root rights.${RESET_COLOR}" 1>&2
	   exit 1
	fi
}

createAliasFileAndAddProjectDir() {
	# TODO:ashe23
	cd $HOME
	mkdir -p $PROJECTS_ROOT_DIR
	# checks if .bash_aliases file exists
	if [ -f $HOME/.bash_aliases ]; then
    	echo "${RED}File  .bash_aliases already exists! Do you want to replace it? (y/N)${RESET_COLOR}";
    	read replaceFile
    	if [ "$replaceFile" = 'y' ] || [ "$replaceFile" = 'Y' ]; then
			echo 'alias desk="cd $HOME/Desktop"
alias sysupd="sudo apt update"
alias sysupg="sudo apt upgrade"
alias yd="cd $HOME/Yandex.Disk"
alias dow="cd $HOME/Downloads"
alias projects="cd $HOME/'$PROJECTS_ROOT_DIR'"' > .bash_aliases;
		else
			echo 'skipping...';
			sleep 1s;
		fi
	fi
}

showProgramList() {
	echo "${BACK_MAGENTA}List of programs${RESET_BACK_COLOR}\n"
	isProgInstalled mc
	isProgInstalled git
	isProgInstalled curl
	isProgInstalled htop
	isProgInstalled top
	isProgInstalled subl
	isProgInstalled yandex-disk
	isProgInstalled gimp		
	isProgInstalled cherrytree
	isProgInstalled youtube-dl		
	isProgInstalled vlc
	isProgInstalled keepass2
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
	apt install apache2
	apt install mysql-server
	apt install php libapache2-mod-php php-mcrypt php-mysql
}


install_YandexDisk() {
    bIsInstalled yandex-disk
	return_val=$?
	if [ "$return_val" -eq "0" ];then
		wget -P $HOME $YANDEXDISK
        cd $HOME
        dpkg -i yandex-disk_latest_amd64.deb
        yandex-disk setup
	fi
}

install_OpenGL() {
    apt install freeglut3 freeglut3-dev
    apt install binutils-gold
    # need this libs for ubuntu
    apt install libxmu-dev libxi-dev
}

install_compilers() {
	apt install g++
}

install_MC() {
	apt install mc
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
	apt install htop
}

install_CURL() {
	apt install curl
}

install_Gimp() {
    bIsInstalled gimp
	return_val=$?
	if [ "$return_val" -eq "0" ];then
		add-apt-repository ppa:otto-kesselgulasch/gimp
	    apt install gimp
	fi
}

install_Sublime3() {
    bIsInstalled subl
	return_val=$?
	if [ "$return_val" -eq "0" ];then
		add-apt-repository ppa:webupd8team/sublime-text-3
	    apt install sublime-text-installer
	fi
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
	apt install nodejs
	apt install build-essential
	apt install npm
}


install_NodePackages() {
	npm install -g bower
	npm install -g modernizr
}

install_CherryTree() {
    bIsInstalled cherrytree
	return_val=$?
	if [ "$return_val" -eq "0" ];then
		add-apt-repository ppa:vincent-c/cherrytree
	    apt install cherrytree
	fi
}

install_VLCplayer() {	
	apt install vlc
}

install_YOUTUBEDL() {
    bIsInstalled youtube-dl
	return_val=$?
	if [ "$return_val" -eq "0" ];then
		add-apt-repository ppa:nilarimogard/webupd8
	    apt install youtube-dl
	fi
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

# installing minimal program bundles
installMinimalBundle() {
	# createAliasFileAndAddProjectDir
	install_compilers
	install_MC
	install_Git
	install_HTOP
	install_CURL
}

install_KeePassX() {
    bIsInstalled keepass2
	return_val=$?
	if [ "$return_val" -eq "0" ];then
		apt-add-repository ppa:jtaylor/keepass
        apt install keepass2
	fi
}

install_MeldDiff() {
    apt install meld
}

installEssentialPrograms() {
	apt update
	install_Archivators
	install_Sublime3	
	install_OKULAR
	install_CherryTree
	install_VLCplayer
	install_YOUTUBEDL
	install_KeePassX
	install_MeldDiff
	install_Gimp
	install_YandexDisk
	apt upgrade
}

installWEBcomponents() {
	apt update
	install_LAMP
	install_Composer
	install_NODEJS
	install_Symfony
	install_PHPUnit
	install_NodePackages
	apt upgrade
}

# initial function that accepts user input and asking question which programs to install
init() {
    # script must run from root , or root rights ex."sudo"
    checkForRoot
    # showing which programs are installed and which are not
    echo '\n'
    showProgramList
    echo '\n'
    show_WEBcomponents
    echo '\n'
    echo "${BLUE}Do you want to install missing programs?(y/N):${RESET_COLOR}"

    # ask user to install missing programs
    read question
    if [ "$question" = "y" ] || [ "$question" = "Y" ]; then
        echo "${BLUE}Both WEB and OS components? (y - both, 1 - only OS , 2 - only WEB):${RESET_COLOR}"
        read component
        if [ -z "$component" ]; then
            echo "Aborting."
            exit 1;
        elif [ "$component" = "y" ] || [ "$component" = "Y" ]; then
            echo "installing both..."
            sleep 2s
            installMinimalBundle
            installEssentialPrograms
            installWEBcomponents
            showProgramList
            echo '\n'
            show_WEBcomponents
            echo '\n'
        elif [ "$component" -eq "1" ]; then
            echo "installing OS..."
            sleep 2s;
            installMinimalBundle
            installEssentialPrograms
            echo '\n'
            showProgramList
            echo '\n'
        elif [ "$component" -eq "2" ]; then
            echo "installing WEB..."
            sleep 2s;
            installWEBcomponents
            echo '\n'
            show_WEBcomponents
            echo '\n'
        fi
    else
        echo "Aborting."
        exit 1;
    fi
}

# if -i flag used we just showing information about programs
if [ "$1" = "-i" ]; then
	echo '\n'
	showProgramList
	echo '\n'
	show_WEBcomponents
	echo '\n'
	exit 1;
fi
# -y flag for installing only yandex disk
if [ "$1" = "-y" ]; then
    echo '\nInstalling Yandex disk\n';
    sleep 2s;
    yandex-disk setup
fi
# -m flag for installing only minimal bundle
if [ "$1" = "-m" ]; then
    echo '\nInstalling minimal bundle\n';
    sleep 2s;
    installMinimalBundle
    exit 1;
fi

# script start here
init
