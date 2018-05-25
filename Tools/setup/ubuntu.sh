#! /usr/bin/env bash

# script directory
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# check ubuntu version
# instructions for 16.04, 18.04
# otherwise warn and point to docker?
UBUNTU_RELEASE=`lsb_release -rs`

if [[ "${UBUNTU_RELEASE}" == "14.04" ]]
then
	echo "Ubuntu 14.04 unsupported, see docker px4io/px4-dev-base"
	exit 1
elif [[ "${UBUNTU_RELEASE}" == "16.04" ]]
then
	echo "Ubuntu 16.04"
elif [[ "${UBUNTU_RELEASE}" == "18.04" ]]
then
	echo "Ubuntu 18.04"
	echo "WARNING, instructions only tested on Ubuntu 16.04"
fi


# Parameter handling
#echo "I was called with $# parameters"
echo "Script supports the following flags to enable features: --gazebo --jmavsim --rtps --ros --nuttx"
while [ "$#" -gt "0" ]
do
    case "$1" in
        --gazebo) 
            #echo "Gazebo"
            _enable_gazebo=true
            ;;
        --jmavsim) 
            #echo "jMAVSim"
            _enable_jmavsim=true
            ;;
        --ros) 
            #echo "ROS/Gazebo"
            _enable_ros_gazebo=true
            ;;
        --rtps) 
            #echo "RTPS"
            _enable_rtps=true
            ;;
        --ros) 
            #echo "nuttx"
            _enable_nuttx=true
            ;;
        *) echo " WARNING: Bad option: $1"
            ;;
    esac
    shift
done

if [[ ${_enable_gazebo} && ${_enable_ros_gazebo} ]]
then 
      _enable_gazebo=''
      echo " IGNORED: --gazebo (included in --ros)"
fi

echo "Enabled Features"
if [[ ${_enable_gazebo} ]];then echo _enable_gazebo: ${_enable_gazebo};fi
if [[ ${_enable_jmavsim} ]];then echo _enable_jmavsim: ${_enable_jmavsim};fi
if [[ ${_enable_ros_gazebo} ]];then echo _enable_ros_gazebo: ${_enable_ros_gazebo};fi
if [[ ${_enable_rtps} ]];then echo _enable_rtps: ${_enable_rtps};fi
if [[ ${_enable_nuttx} ]];then echo _enable_nuttx: ${_enable_nuttx};fi



export DEBIAN_FRONTEND=noninteractive
sudo apt-get update -yy --quiet
sudo apt-get -yy --quiet --no-install-recommends install \
	bzip2 \
	ca-certificates \
	ccache \
	cmake \
	g++ \
	gcc \
	git \
	lcov \
	make \
	ninja-build \
	python-pip
	rsync \
	unzip \
	wget \
	wget \
	xsltproc \
	zip

# python dependencies
python -m pip install --user --upgrade pip setuptools wheel
python -m pip install --user -r ${DIR}/requirements.txt


# java (jmavsim or fastrtps)
if [[ ${_enable_jmavsim} || ${_enable_ros_gazebo} ]]
then 
    sudo apt-get -y --quiet --no-install-recommends install \
	default-jre-headless \
	default-jdk-headless \
fi




# Disable all feature variables - in case file is called multiple times in same context:
_enable_gazebo=''
_enable_jmavsim=''=''
_enable_ros_gazebo=''
_enable_rtps=''
_enable_nuttx=''

