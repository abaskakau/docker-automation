#!/bin/bash

echo "10.177.176.213 build.pentaho.com builds.pentaho.com" >> /etc/hosts
aria2c -x5 http://build.pentaho.com/hosted/7.0-QAT/283/pentaho-business-analytics-7.0-QAT-283-x64.bin
chown devuser:devuser pentaho-business-analytics-7.0-QAT-283-x64.bin
chmod +x pentaho-business-analytics-7.0-QAT-283-x64.bin