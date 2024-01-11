#!/bin/bash
if [[ "${ES_ENABLED}" == "true" ]]; then
    su -c /usr/share/elasticsearch/bin/elasticsearch "$NB_USER" > /var/log/elasticsearch/init.log 2>&1 & # ElasticSearch 8
fi
if [[ "${JUPYTERHUB_ENABLED}" == "true" ]]; then
    jupyterhub -f /etc/jupyter/jupyterhub_custom_config.py > /etc/jupyter/jupyterhub.log 2>&1 & # TODO: config is obsolete!
fi
start-notebook.sh $@
