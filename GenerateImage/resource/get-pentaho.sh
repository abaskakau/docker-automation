#!/bin/bash

echo "10.177.176.213 build.pentaho.com builds.pentaho.com" >> /etc/hosts
aria2c -x5 http://build.pentaho.com/hosted/${BUILD_VERSION}/${BUILD_NUMBER}/pentaho-business-analytics-${BUILD_VERSION}-${BUILD_NUMBER}-x64.bin
chmod +x pentaho-business-analytics-${BUILD_VERSION}-${BUILD_NUMBER}-x64.bin