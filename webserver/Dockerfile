# This image runs a simple webserver that send logs to the ELK Stack on AWS

# Logstash's IP is automatically set on Filebeat configuration

# Unfortunately Alpine repositories doesnt include glibc, so I am using this image, which is very 
# used on the wild and can be trusted
FROM frolvlad/alpine-glibc
COPY start.sh /tmp/
COPY filebeat.yml /tmp/
COPY webserver.rb /tmp/
COPY logstash-beats.crt /tmp/

RUN apk --no-cache add curl ruby && \ 
    curl https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.3.0-linux-x86_64.tar.gz -o /tmp/filebeat.tar.gz && \
    mkdir /etc/filebeat && \
    cd /tmp && \
    tar xzf filebeat.tar.gz && \
    cd filebeat-* && \
    cp filebeat /bin && \
    cd /tmp && \    
    cp filebeat.yml /etc/filebeat/filebeat.yml && \
    cp logstash-beats.crt /etc/filebeat && \
    rm -rf /tmp/*beat* && \
    gem install --no-ri sinatra && \
    mv /tmp/webserver.rb /bin && \
    chmod a+x /bin/webserver.rb && \
    mv /tmp/start.sh /bin && \
    chmod a+x /bin/start.sh
