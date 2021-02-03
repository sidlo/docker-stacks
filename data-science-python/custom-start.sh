#!/bin/bash
if [[ "${ES_ENABLED}" == "yes" ]]; then
    service elasticsearch start
fi
#su - $NB_USER
start-notebook.sh $@
