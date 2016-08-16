#!/bin/bash

locale-gen en_US.UTF-8 && dpkg-reconfigure locales
apt-get update
apt-get upgrade -y
apt-get -y -q install wget tar aria2