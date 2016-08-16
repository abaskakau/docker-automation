#!/bin/bash

bash $PENTAHO_HOME/ctlscript.sh start postgresql
bash $PENTAHO_HOME/ctlscript.sh start baserver
bash $PENTAHO_HOME/ctlscript.sh start data-integration-server