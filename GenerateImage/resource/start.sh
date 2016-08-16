#!/bin/bash

sh .installer.sh

bash $PENTAHO_HOME/ctlscript.sh start postgresql
bash $PENTAHO_HOME/ctlscript.sh start baserver
bash $PENTAHO_HOME/ctlscript.sh start data-integration-server