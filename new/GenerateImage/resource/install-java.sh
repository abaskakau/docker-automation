#!/bin/bash

# Install java
cd /opt
wget --progress=bar:force --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/7u71-b14/jdk-7u71-linux-x64.tar.gz"
tar xzf jdk-7u71-linux-x64.tar.gz

update-alternatives --install /usr/bin/java java /opt/jdk1.7.0_71/jre/bin/java 200000
update-alternatives --install /usr/bin/javaws javaws /opt/jdk1.7.0_71/jre/bin/javaws 200000
update-alternatives --install /usr/bin/jps jps /opt/jdk1.7.0_71/bin/jps 200000
update-alternatives --install /usr/bin/javac javac /opt/jdk1.7.0_71/bin/javac 200000
update-alternatives --install /usr/bin/jar jar /opt/jdk1.7.0_71/bin/jar 200000
# update-alternatives --install /usr/lib64/mozilla/plugins/libjavaplugin.so libjavaplugin.so.x86_64 /opt/jdk1.7.0_71/jre/lib/amd64/libnpjp2.so 200000

# Cleanup
rm jdk-7u71-linux-x64.tar.gz 
rm jdk1.7.0_71/src.zip
