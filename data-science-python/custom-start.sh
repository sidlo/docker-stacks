#!/bin/bash
if [[ "${ES_ENABLED}" == "true" ]]; then
    service elasticsearch start
fi
if [[ "${JUPYTERHUB_ENABLED}" == "true" ]]; then
    jupyterhub -f jupyterhub_custom_config.py > jupyterhub.log 2>&1 &
fi
start-notebook.sh $@
