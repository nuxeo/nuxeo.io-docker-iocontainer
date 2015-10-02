#!/bin/sh -x

# Install java
apt-get remove -y --purge openjdk-7-jdk
add-apt-repository -y ppa:webupd8team/java && apt-get update
echo "debconf shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
echo "debconf shared/accepted-oracle-license-v1-1 seen true" | debconf-set-selections
apt-get install -y oracle-java8-installer

# Nuxeo setup
wget -q "http://www.nuxeo.org/static/latest-io-snapshot/nuxeo,io,tomcat,zip,7.10" -O /tmp/nuxeo-distribution-tomcat.zip

mkdir -p /tmp/nuxeo-distribution
unzip -q -d /tmp/nuxeo-distribution /tmp/nuxeo-distribution-tomcat.zip
DISTDIR=$(/bin/ls /tmp/nuxeo-distribution | head -n 1)
mkdir -p $NUXEO_HOME
mv /tmp/nuxeo-distribution/$DISTDIR/* $NUXEO_HOME
rm -rf /tmp/nuxeo-distribution*
chmod +x $NUXEO_HOME/bin/nuxeoctl

mkdir -p /var/lib/nuxeo/data
mkdir -p /var/log/nuxeo
mkdir -p /var/run/nuxeo

# Override some default template files
cp -Rf /root/io/* ${NUXEO_HOME}/templates/default/ && rm -rf /root/io

chown -R $NUXEO_USER:$NUXEO_USER /var/lib/nuxeo
chown -R $NUXEO_USER:$NUXEO_USER /var/log/nuxeo
chown -R $NUXEO_USER:$NUXEO_USER /var/run/nuxeo

cat << EOF >> $NUXEO_HOME/bin/nuxeo.conf
nuxeo.log.dir=/var/log/nuxeo
nuxeo.pid.dir=/var/run/nuxeo
nuxeo.data.dir=/var/lib/nuxeo/data
nuxeo.wizard.done=true
EOF
