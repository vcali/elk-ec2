#!/bin/bash

# This script will build an Ansible docker image to deploy ELK Stack on AWS
# Then, it wil run a webserver on the local machine that sends its logs to the ELK Stack previously deployed
# The region on AWS is N Virginia

# For it to work, you need to insert your AWS keys on the ansible/Dockerfile file

MY_IP=$1
KEY_NAME=$2
KEY_PATH=$3
DOCKER=`which docker`

usage() {
  echo ""
  echo "This script needs to be run with sudo because of docker"
  echo "It also needs your public IP, the name of the key pair that will be used to deploy instances, and the absolute path to your AWS ssh key"
  echo "Example:"
  echo "sudo $0 187.101.86.246 generic-key-pair /home/user/ssh-key.pem" 
  echo ""
}

if [ ! "$#" -eq 3 ] ; then
  usage
  exit 1
fi


if [ ! -f $KEY_PATH ] ; then
  echo "SSH key not found in given path"
  exit 1
fi

cd ansible
echo $MY_IP > my_ip
cp $KEY_PATH ssh-key.pem
echo $KEY_NAME > key_name

# Here the ELK Stack will be deployed
$DOCKER build -t fender:deploy-ec2-elk .
$DOCKER run -v `pwd`:/ansible -it fender:deploy-ec2-elk /ansible/deploy-everything.sh

cd ..
cd webserver

# Here a simple webserver will run on local machine, already pointing Filebeat to Logstash instance
$DOCKER build -t fender:webserver .
echo "Kibana's public IP is `awk '/kibana/{getline; print}' ../ansible/ec2_hosts`"
$DOCKER run --add-host elk-fender.vcali.com:`awk '/logstash/{getline; print}' ../ansible/ec2_hosts` -it -p 8080:8080 fender:webserver start.sh

cd ..

rm -f ansible/my_ip
rm -f ansible/key_name
rm -f ansible/ec2_hosts
rm -f ansible/ssh-key.pem
