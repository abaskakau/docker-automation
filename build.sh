#!/bin/bash

buildVersion=$1
buildNumber=$2
tag=$3

if [ -z "$buildVersion" ] || [ -z "$buildNumber" ]; then
  echo "Usage: $0 <build version> <build number>"
  exit 1
fi

echo "Building docker image for $buildVersion build $buildNumber"

cp build.properties GenerateImage/resource/
docker build --build-arg BUILD_VERSION=$buildVersion --build-arg BUILD_NUMBER=$buildNumber -t "abaskakau/test" GenerateImage/

rm -rf GenerateImage/resource/build.properties