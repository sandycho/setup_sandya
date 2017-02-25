#!/bin/bash
#UBUNTU 14.04 LTS Trusty
#TIPS:
#lsb_release -cs -> trusty: returns the name of your Ubuntu distribution, such as xenial.
#global variable
proc_msg="Processing:"
abort_msg="Failed. Aborting..."
ok_msg="OK"
ko_msg="KO"
log_info="INFO >"
log_warning="WARNING >"
TASK_NUM=0

#SUCCESS FLAG
success_flag=-1

#INFO MSG
ALREADY_INSTALL="Already installed."
ALREADY_DOWNLOADED="Already downloaded."
ALREADY_UNZIPPED="Already unzipped."

log_proc_msg="$log_info $proc_msg"
log_result_ok_msg="$log_info $ok_msg"
log_result_ko_msg="$log_info $ko_msg"

#FUNCTIONS
# log
function log {
	msg=""

	if [ $1 = 0 ]; then
		msg="$log_info $2"
	else
		msg="$log_warning $2"
    fi
	
	output=$(echo $msg)
	echo $output
	echo $output >> log.txt
}

function log_ok {
	echo "$log_info $1: $ok_msg"
}

function log_ko {
	echo "$log_info $1: $ko_msg"
}

# helpers
function task_counter {
	TASK_NUM=$(($TASK_NUM+1))
	output=$(echo -e "\n$log_info TASK $TASK_NUM.- ####################################")
	echo $output
	echo $output >> log.txt
}

function check_result {

	if [ $? -ne 0 ]; then
		output=$(log_ok "$1")
		echo $output
		echo $output >> log.txt
		result=0
	else
		output=$(log_ko "$1")
		echo $output
		echo $output >> log.txt
		result=1
	fi
	
	if [ $success_flag -lt 1 ]; then
		success_flag=$result
	fi
}

function check_condition_result {
	if [ -n $2 ]; then 
		output=$(log_ok "$1")
		echo $output
		echo $output >> log.txt
		result=0
	else
		output=$(log_ko "$1")
		echo $output
		echo $output >> log.txt
		result=1
	fi
	
	if [ $success_flag -lt 1 ]; then
		success_flag=$result
	fi
}


#TASKS
#create dir
echo "--------------------------"

output=$(echo "$log_info `date`")
echo $output
echo $output > log.txt

#-----------------------------------------------------------------------------------------------
task_counter
#Git
prog_path=`which git`
check_condition_result "Checking Git installation..." ""$prog_path""
if [ $result = 0 ]; then
	log 1 "$ALREADY_INSTALL"
else
	task_desc="Installing Git..."
	log 0 "$task_desc"
	apt-get install -y git-all
	check_result "$task_desc"
fi

#-----------------------------------------------------------------------------------------------
task_counter
#JAVA 8u121
prog_path=`which java`
check_condition_result "Checking Java installation..." ""$prog_path""
if [ $result = 0 ]; then
	log 1 "$ALREADY_INSTALL"
else
	task_desc="Installing Java8u121..."
	log 0 "$task_desc"
	
	
	prog_path=`find jdk-8u121-linux-x64.tar.gz`
	check_condition_result "Checking java download..." ""$prog_path""
	if [ $result = 0 ]; then
		log 1 "$ALREADY_DOWNLOADED"
	else
		wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-x64.tar.gz
	fi
	
	prog_path=`find /usr -type d -name jdk1.8.*_121`
	check_condition_result "Checking java unzip in /usr/java/jdk1.8.*_121..." ""$prog_path""
	
	#unzip
	task_desc="Unzipping..."
	if [ $result = 0 ]; then
		log 1 "$ALREADY_UNZIPPED"
	else
		mkdir -p /usr/java
		tar zxvf jdk-*-linux-x64.tar.gz --directory="/usr/java"
		check_result "$task_desc"
	fi
	
	#removing tar.gz
	task_desc="Removing tar.gz..."
	if [ $result = 0 ]; then
		#rm -R jdk-*-linux-x64.tar.gz
		echo "COMMENT..."
		check_result "$task_desc"
	fi
fi

#-----------------------------------------------------------------------------------------------
task_counter
#Maven
proc_name="Maven3"
maven_version="3.3.9"
prog_path=`which mvn`
check_condition_result "Checking $proc_name installation..." ""$prog_path""
if [ $result = 0 ]; then
	log 1 "$ALREADY_INSTALL"
else
	task_desc="Installing $proc_name..."
	log 0 "$task_desc"
	
	prog_path=`find apache-maven-$maven_version-bin.tar.gz`
	check_condition_result "Checking $proc_name download..." ""$prog_path""
	if [ $result = 0 ]; then
		log 1 "$ALREADY_DOWNLOADED"
	else
		wget http://apache.rediris.es/maven/maven-3/$maven_version/binaries/apache-maven-$maven_version-bin.tar.gz
		tar zxvf apache-maven-$maven_version-bin.tar.gz
		mv apache-maven-$maven_version /usr/opt
		check_result "$task_desc"
	fi
	
	
	#removing tar.gz
	task_desc="Removing tar.gz..."
	if [ $result = 0 ]; then
		#rm -R apahce-maven-$maven_version-bin.tar.gz
		echo "COMMENT..."
		check_result "$task_desc"
	fi
fi

#-----------------------------------------------------------------------------------------------
task_counter
#Ansible
proc_name="Ansible"
prog_path=`which ansible`
check_condition_result "Checking $proc_name installation..." ""$prog_path""
if [ $result = 0 ]; then
	log 1 "$ALREADY_INSTALL"
else
	task_desc="Installing $proc_name..."
	log 0 "$task_desc"
	apt-get install -y software-properties-common
	apt-add-repository ppa:ansible/ansible
	apt-get update
	apt-get install -y ansible
	check_result "$task_desc"
fi

#-----------------------------------------------------------------------------------------------
task_counter
#Notepadqq
prog_path=`which notepadqq`
check_condition_result "Checking Notepadqq installation..." ""$prog_path""
if [ $result = 0 ]; then
	log 1 "$ALREADY_INSTALL"
else
	log 0 "Installing notepadqq..."
fi

#-----------------------------------------------------------------------------------------------
#https://nodejs.org/es/download/package-manager/
task_counter
proc_name="Nodejs"
prog_path=`which nodejs`
check_condition_result "Checking $proc_name installation..." ""$prog_path""
if [ $result = 0 ]; then
	log 1 "$ALREADY_INSTALL"
else
	task_desc="Installing $proc_name..."
	log 0 "$task_desc"
	
	curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
	sudo apt-get install -y nodejs
	sudo apt-get install -y build-essential
	
	check_result "$task_desc"
fi

#-----------------------------------------------------------------------------------------------
#sudo apt-get install -y --no-install-recommends \
#    apt-transport-https \
#    ca-certificates \
#    curl \
#    software-properties-common
#https://docs.docker.com/engine/installation/linux/ubuntu/
task_counter
proc_name="Docker"
prog_path=`which docker`
check_condition_result "Checking $proc_name installation..." ""$prog_path""
if [ $result = 0 ]; then
	log 1 "$ALREADY_INSTALL"
else
	task_desc="Installing $proc_name..."
	log 0 "$task_desc"
	
	#setup the repository
	apt-get install -y --no-install-recommends apt-transport-https ca-certificates software-properties-common
	curl -fsSL https://apt.dockerproject.org/gpg | sudo apt-key add -
	apt-key fingerprint 58118E89F3A912897C070ADBF76221572C52609D
	sudo add-apt-repository \
       "deb https://apt.dockerproject.org/repo/ \
       ubuntu-$(lsb_release -cs) \
       main"
	   
	#install
	apt-get update
	apt-get -y install docker-engine
	
	#on production
	#apt-cache madison docker-engine
	
	check_result "$task_desc"
fi

#-----------------------------------------------------------------------------------------------
#https://www.virtualbox.org/wiki/Linux_Downloads
task_counter
proc_name="VirtualBox"
prog_path=`which virtualbox`
check_condition_result "Checking $proc_name installation..." ""$prog_path""
if [ $result = 0 ]; then
	log 1 "$ALREADY_INSTALL"
else
	task_desc="Installing $proc_name..."
	log 0 "$task_desc"
	
	#setup the repository
	apt-key fingerprint 58118E89F3A912897C070ADBF76221572C52609D
	sudo add-apt-repository \
       "http://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib"
	   
	#keys 
	wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
	wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
	
	#key fingerprint
	apt-key fingerprint B9F8D658297AF3EFC18D5CDFA2F683C52980AECF
	apt-key fingerprint 7B0FAB3A13B907435925D9C954422A4B98AB5139
	   
	#install
	sudo apt-get update
	sudo apt-get install virtualbox-5.1
	
	#Note: Ubuntu/Debian users might want to install the dkms package to ensure that the 
	#virtualBox host kernel modules (vboxdrv, vboxnetflt and vboxnetadp) are properly updated 
	#if the linux kernel version changes during the next apt-get upgrade.
	sudo apt-get install dkms
	
	#What to do when experiencing The following signatures were invalid: BADSIG ... 
	#when refreshing the packages from the repository? 
	# sudo -s -H
	# apt-get clean
	# rm /var/lib/apt/lists/*
	# rm /var/lib/apt/lists/partial/*
	# apt-get clean
	# apt-get update
	
	check_result "$task_desc"
fi


#-----------------------------------------------------------------------------------------------



#-----------------------------------------------------------------------------------------------


#MANUAL SETTINGS

#JAVA_HOME
echo "WARNING!!!!"
echo "MANUAL SETTINGS"
echo -e "export JAVA_HOME=/usr/java/jdk1.8.0_121 && export PATH=\$JAVA_HOME/bin:\$PATH && export MAVEN3_HOME=/usr/opt/apache-maven-$maven_version && export PATH=\$MAVEN3_HOME/bin:\$PATH"

echo "|----------------------------------------------"
echo "|"
if [ $success_flag = 0 ]; then
	echo "|>>>>> BUILD SUCCESS"
else
	echo "|>>>>> BUILD FAILED: $success_flag"
fi
echo "|"
echo "|----------------------------------------------"