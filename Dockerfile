# Nuxeo IO Container image is a nuxeo-base image which install expected java and Nuxeo distribution tomcat
#
# VERSION               0.0.1

FROM       quay.io/nuxeoio/nuxeo-base
MAINTAINER Nuxeo <contact@nuxeo.com>

# Copy scripts
ADD nuxeo-install.sh /root/nuxeo-install.sh
ADD start.sh /root/start.sh
ADD io /root/io

# Download & Install Nuxeo
ONBUILD RUN /bin/bash /root/nuxeo-install.sh

CMD ["/root/start.sh"]
