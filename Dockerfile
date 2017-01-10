# This Dockerfile is prepared for a container to process daily job
FROM ubuntu:16.04
MAINTAINER Casper Chiang <casperchiang@chocolabs.com>
RUN apt-get -y update
# install python3, python3-pip and cron
RUN apt-get -y install cron
RUN apt-get -y install python3
RUN apt-get -y install python3-pip
# autoclean
RUN apt-get clean
RUN apt-get autoclean
RUN apt-get autoremove
# create work dir
RUN ["mkdir", "-p", "/usr/src/app"]
WORKDIR /usr/src/app
# init timezone
RUN ln -sf /usr/share/zoneinfo/Asia/Taipei /etc/localtime
# Install rsyslog to keep container running.
RUN apt-get update
RUN apt-get -y install rsyslog
# Copy files
COPY crontabfile /usr/src/app
COPY wake-me-up.py /usr/src/app
COPY run.sh /usr/src/app
# init cron
RUN crontab /usr/src/app/crontabfile
RUN cp /usr/src/app/crontabfile /etc/crontab
RUN touch /var/log/cron.log
# attach permission of execution to run.sh file.
RUN chmod +x /usr/src/app/run.sh
WORKDIR /usr/src/app
ENTRYPOINT ["/bin/bash", "/usr/src/app/run.sh"]
