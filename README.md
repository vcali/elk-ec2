Deploying ELK Stack On AWS
==========================

This project deploys a fully operational ELK Stack on AWS and a example webserver that runs locally and send logs to the stack.

Before We Start
===============

A few observations before we start:

  * The project was made assuming that an IAM user has already been created
  * To guarantee that it will work anywhere, I used Docker, so it is a requirement
  * The user needs to insert his own AWS credentials on ./ansible/Dockerfile
  * I made a video showing the deploy: https://www.dropbox.com/sh/w7catzpk5antxka/AACye7640mGp2edl4uQpkXPEa?dl=0

I suggest the user to download it instead of opening it directly on Dropbox - the stream may decrease the video quality

How It Works
============

Everything is started by running the `run-me.sh` script.
The script must be run with an user that can run Docker.

The usage is very simple. It needs 3 parameters:

```
sudo ./run-me.sh <your-public-ip> <aws-key-pair-name> <path-to-aws-ssh-key>
```

  * <your-public-ip>            needed to create the rules that allows the user to access instances
  * <aws-key-pair-name>         the name of the key pair that will be used on the instances
  * <path-to-aws-ssh-key>       the path to the user ssh key

Example:

```
sudo ./run-me.sh 187.101.86.246 generic-key-pair /home/user/ssh-key.pem
```

Step By Step
============

First of all, a docker image will be created. This image will deploy all the infrastructure needed to run ELK Stack:

  * 1 VPC
  * 3 Subnets
  * 1 Route Table
  * 1 Internet Gateway
  * 3 Security Groups
  * A lot of network ACLs, ensuring access only to the user, Oracle (to download latest Java), ELK repository and between instances
  * 3 instances - one for each app

When the ELK Stack deploy finishes, a second image will be built.
That second image will start a simple webserver and the Filebeat app.
During the process, Logstash's IP will be retrieved and injected into Filebeat's configuration.
The communication between Filebeat and Logstash is protected by SSL. As this is a demo project, the self-signed certificate and its key are available here.

What I Used
===========

  * Ansible and its Cloud Modules (doc here: http://docs.ansible.com/ansible/list_of_cloud_modules.html)
  * Docker
  * Ruby's Sinatra, to deploy the webserver
  * Instances run on Amazon Linux
  * Alpine Linux, to keep docker images as small as possible (glibc image downloaded from here: https://hub.docker.com/r/frolvlad/alpine-glibc/)
  * Nginx on top of Kibana

Final Thoughts
==============

Oracle seems to like to change its IPs every day. For that, there may be some problems during the Java download. I tried to allow instances to access all Oracle's IPs I found during the development, but the very next day some IPs changed, so an timeout error may happen :(
For this project to run correctly, Ansible version must be the latest available (right now its the version 2.2.1.0-r0
). The latest version is always available on Pip repositories, which is what I used to download Ansible (doc here: http://docs.ansible.com/ansible/intro_installation.html#latest-releases-via-pip).
A lot of the modules I used are available only on the more recent versions.
The latest version of ELK Stack, including Filebeat, at the moment of the development is 5.3.0-1
This is the version installed and running in the stack.
While Ansible will ensure the version installed is always the latest, some future upgrade may break things. For now, its working perfectly.

