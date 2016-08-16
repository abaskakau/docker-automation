#!/bin/bash

export PENTAHO_HOME=$1
export PRODUCT_NAME=$2
export PENTAHO_BUILD=$3
export TIMEOUT=$4

export TIMEOUT=$(( ${TIMEOUT}/10 ))
echo TIMEOUT: $TIMEOUT

# Print usage information
function usage {
  echo "Usage: $0 <pentaho_home> <baserver|data-integration-server|carte> <pentaho-build> <timeout - sec>"
}

# Parse CLI options
if [ $# -lt 3 ]; then
  usage $0
  exit 1
fi


echo PENTAHO_HOME: ${PENTAHO_HOME}
cd ${PENTAHO_HOME}

APP_STARTED_LINE="Server startup in"
CARTE_STARTED_LINE="Carte - Created listener for webserver"

baserver() {
#  export CATALINA_OPTS="-XX:MaxPermSize=512m -javaagent:$HOME/share/jacoco/lib/jacocoagent.jar=destfile=$HOME/share/jacoco/report/${PENTAHO_BUILD}/jacoco_baserver.exec,output=file,address=*,append=true"
  export CATALINA_OPTS="-Xmx8192m"
  echo "CATALINA_OPTS: ${CATALINA_OPTS}"
  ${PENTAHO_HOME}/ctlscript.sh start baserver
}

diserver() {
#  export CATALINA_OPTS=-javaagent:$HOME/share/jacoco/lib/jacocoagent.jar=destfile=$HOME/share/jacoco/report/${PENTAHO_BUILD}/jacoco_diserver.exec,output=file,address=*,append=true
  echo "CATALINA_OPTS: ${CATALINA_OPTS}"
  ${PENTAHO_HOME}/ctlscript.sh start data-integration-server
}

carte() {
#  export OPT=-javaagent:$HOME/share/jacoco/lib/jacocoagent.jar=destfile=$HOME/share/jacoco/report/${PENTAHO_BUILD}/jacoco_carte.exec,output=file,address=*,append=true
  echo "OPT: ${OPT}"
  ${PENTAHO_HOME}/design-tools/data-integration/carte.sh $HOME/share/carte.xml>carte.log 2>&1 &
}


## ################################### ####
## FUNCTION:     verify_startup
## DESCRITION:   verifies Pentaho Enterprise Edition component startup
## PARAMETERS:
##         $1 - Component long name
##         $2 - Path to log file for startup verification
##         $3 - String to find in startup log (startup indicator)
##         $4 - Counter. (Startup verification max duration) = (Counter) x (sleep_delay) seconds

verify_startup(){

	COMPONENT_NAME=$1
	STARTUP_LOG=$2
	STARTUP_INDICATOR=$3
	STARTUP_COUNTER=$4

	sleep_delay=10 # seconds between checks
	seconds=0

	let "max_startup_time = $STARTUP_COUNTER * $sleep_delay"


	COUNTER=0
        while [  $COUNTER -lt $STARTUP_COUNTER ];
	do
		sleep $sleep_delay
		if [[ -r ${STARTUP_LOG} ]]
		then
			grep "${STARTUP_INDICATOR}" ${STARTUP_LOG} >/dev/null 2>&1
			if [[ $? = 0 ]]
		        then
				let "seconds = ${COUNTER} * $sleep_delay"
		                echo  "${COMPONENT_NAME} has started after $seconds seconds."
				COUNTER=${STARTUP_COUNTER}
		        else
		                echo "${COMPONENT_NAME} has not started yet. Waiting another ${sleep_delay} seconds interval..."
			fi
		else
			echo "Cannot find log file ${STARTUP_LOG}. Probably the file has not appeared yet."
		fi
			let "COUNTER = $COUNTER + 1"
	done
	if [[ $COUNTER = ${STARTUP_COUNTER} ]]
	then
		echo "PAY ATTENTION TO ${COMPONENT_NAME} STARTUP! It has not started after ${max_startup_time} seconds."
		cat ${STARTUP_LOG}
		return 2
	fi

	return 0
}
## =================================== ####



if [ "$PRODUCT_NAME" = "baserver" ]; then
  rm -f ${PENTAHO_HOME}/server/biserver-ee/tomcat/logs/catalina.out
  baserver
  verify_startup "${PRODUCT_NAME}" ${PENTAHO_HOME}/server/biserver-ee/tomcat/logs/catalina.out "${APP_STARTED_LINE}" $TIMEOUT
  echo "${PRODUCT_NAME}" startup status: $?
  exit $?
elif [ "$PRODUCT_NAME" = "data-integration-server" ]; then
  rm -f ${PENTAHO_HOME}/server/data-integration-server/tomcat/logs/catalina.out
  diserver
  verify_startup "${PRODUCT_NAME}" ${PENTAHO_HOME}/server/data-integration-server/tomcat/logs/catalina.out "${APP_STARTED_LINE}" $TIMEOUT
  echo "${PRODUCT_NAME}" startup status: $?
  exit $?
elif [ "$PRODUCT_NAME" = "carte" ]; then
  carte
  #verify_startup "${PRODUCT_NAME}" carte.log "${CARTE_STARTED_LINE}" $TIMEOUT
  #echo "${PRODUCT_NAME}" startup status: $?
  #exit $?
fi