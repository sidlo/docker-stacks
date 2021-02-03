#!/bin/bash
if [[ "${ES_ENABLED}" == "true" ]]; then
    service elasticsearch start
fi
start-notebook.sh $@
