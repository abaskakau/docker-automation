#!/bin/bash

# Set environment
export RELEASE=$1
export INSTALLER=$2
export PENTAHO_HOME=$3
export LOG_FILE=/tmp/bitrock_installer.log
OPTIND=1
debug=0
pwd=`pwd`

echo RELEASE: ${RELEASE}
echo INSTALLER: ${INSTALLER}
echo PENTAHO_HOME: ${PENTAHO_HOME}

# Print usage information
function usage {
  echo "Usage: $0 <release> <path-to-installer> <pentaho-home>"
}

# Parse CLI options
if [ $# -lt 3 ]; then
  usage $0
  exit 1
fi

while getopts "dh?:" opt; do
  case "$opt" in
    h|\?)
      usage $0
      exit 0
    ;;
    d)
      debug=1
    ;;
  esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift

curdir=`pwd`
BASEDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${BASEDIR}

#Cleaning /tmp/bitrock_installer*.log files
find /tmp -type f -name "bitrock*" -exec rm -f {} \;

#Generate full install option file
option_file=`mktemp -t pentaho-installer.XXXX`
sed "s|pentaho_home_value|${PENTAHO_HOME}|g" build.properties > $option_file

echo "Installer response file generated in $option_file"

#sudo chown ${USER} installer.option

if [ $debug -eq 1 ]; then
  echo "ls="`sudo ls -la`
  echo "architecture="`uname -a`
  echo "whoami="`whoami`
  echo "file="`sudo file $TMP_DOWNLOAD_FOLDER/pentaho.bin`
fi

# Install pentaho
nohup ${INSTALLER} --optionfile $option_file &
sleep 300

LOG_FILE=`ls /tmp/bitrock_installer*`

grep "Installation completed" ${LOG_FILE}
while [  $? = 1 ]; do
    echo installation is in progress... waiting 60 sec...
    sleep 60
    grep "Installation completed" ${LOG_FILE}
done

echo Installation already finished. Kill install.sh
if ps -eaf | grep "$option_file" | grep -v grep; then
  export pids=`ps -eaf | grep "$option_file" | grep -v grep | awk '{ print $2 }'`
fi
if [ "${pids}" != "" ]; then
  kill -9 ${pids}
fi

#goto the parent folder
cd ${curdir}

if [ -f ${LOG_FILE} ]; then
  echo log file:
  cat ${LOG_FILE}
  grep 'There has been an error.' ${LOG_FILE}
  if [ $? = 0 ]; then
    echo "ERROR: Installation Failed"
    exit -1
  fi
else
  echo "ERROR: Log file ${LOG_FILE} doesn't exist"
  exit -1
fi

jps -v

# Post installation actions - copy jdbc drivers
#export PATH=${PENTAHO_HOME}/java/bin:${PATH}

if [ -d ${PENTAHO_HOME}/jdbc-distribution ]; then
  ${PENTAHO_HOME}/jdbc-distribution/distribute-files.sh ${HOME}/share/jdbc/mysql-connector-java-5.1.30-bin.jar ${HOME}/share/jdbc/ojdbc6.jar
else
  echo "WARNING: ${PENTAHO_HOME}/jdbc-distribution doesn't exist"
fi

#rename sample back
cd ${PENTAHO_HOME}/server/biserver-ee/pentaho-solutions/system/default-content
for file in *.zip*
do
  echo $file
  name=`echo "$file" | cut -d'.' -f1`
  echo moving $name back to zip
  mv "$file" "${name}.zip"
done


