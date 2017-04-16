### This Dockerfile will build an image made to run the Ansible's playbooks to deploy the ELK Stack on EC2
FROM alpine:latest

ENV AWS_ACCESS_KEY_ID=""
ENV AWS_SECRET_ACCESS_KEY=""
ENV AWS_REGION="us-east-1"
ENV ANSIBLE_HOST_KEY_CHECKING="false"
ENV ANSIBLE_SSH_RETRIES="10"

RUN apk add --no-cache ansible py-pip && pip install --upgrade pip && pip install boto boto3 botocore
