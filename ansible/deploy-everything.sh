#!/bin/sh
# This script will launch Ansible to deploy all the infra-structure on AWS and ELK Stack

# Deploying AWS
ansible-playbook /ansible/deploy_aws.yml

# Installing ELK Stack
ansible-playbook -i /ansible/ec2_hosts /ansible/install_elk.yml --private-key=/ansible/key-vcali-nvirg.pem --become-user=root --become-method=sudo 
