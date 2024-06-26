# Start from a core stack version
FROM quay.io/jupyter/pyspark-notebook:2024-02-13
# environmental variables
ENV JUPYTER_ALLOW_INSECURE_WRITES=true

# additinal ubuntu packages:
USER root
RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends vim gawk htop libblas3 liblapack3 libstdc++6 \
    python-setuptools graphviz python3-pydot openssh-server telnet iputils-ping && \ 
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* 

# additional python packages (with the default user of pyspark-notebook):
RUN mamba install --yes --quiet --channel conda-forge \
    'asammdf[gui]' \
    'blas' \
    'bqplot' \
    'catboost' \
    'chainer' \
    'clickhouse-driver' \
    'compress-pickle' \
    'cufflinks-py' \
    'elasticsearch' \
    'findspark' \
    'folium' \
    'geopandas' \
    'geopy' \
    'google-cloud-bigquery' \
    'gpxpy' \
    'graphviz' \
    'hdbscan' \
    'itables' \
    'jupyter_bokeh' \
    'jupyter-lsp-python' \
    'jupyter-resource-usage' \
    'jupyterlab-geojson' \
    'jupyterlab-lsp' \
    'jupyterlab' \
    'nltk' \
    'pandas' \
    'plotly' \
    'polars' \
    'psycopg2-binary' \
    'pydotplus' \
    'pymongo' \
    'pyod' \
    'pyproj' \
    'rasterio' \
    'scrapy' \
    'shap' \
    'tensorflow' \
    'twython' \
    'wfdb' \
    'xgboost' \
    'xmltodict' \
    && \
    # 'alpenglow==1.0.4' \ 
    # 'vaex' \
    # 'qgrid' \ # latest 1.3.1 is too old, needs ipywidgets~=7, which does not work with the newest jupyter
    # 'openpyxl' 'jupyterlab-git' \ # already installed in base image
    # 'sparkmonitor' 'karateclub' 'jupyterlab_latex' \ # older dropped packages
    mamba clean --all -f -y && \
    npm cache clean --force && \
    jupyter lab clean -y && \
    rm -rf ${CONDA_DIR}/share/jupyter/lab/staging && \
    npm cache clean --force && \
    rm -rf /home/${NB_USER}/.cache/yarn && \
    fix-permissions ${CONDA_DIR} && \
    fix-permissions /home/${NB_USER}

## ElasticSearch 8, forces TLS and multi-node by default, we disable them
#RUN wget --progress=dot:giga https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.6.2-amd64.deb && \
#    wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.6.2-amd64.deb.sha512 && \
#    shasum -a 512 -c elasticsearch-8.6.2-amd64.deb.sha512 && \
#    dpkg -i elasticsearch-8.6.2-amd64.deb && \
#    rm elasticsearch-8.6.2-amd64.deb && \
#    rm elasticsearch-8.6.2-amd64.deb.sha512 && \
#    sed -i 's/\(^cluster.initial_master_nodes.*$\)/#\1 # DOCKER-STACKS-MOD: commented out to only run in single node mode/' /etc/elasticsearch/elasticsearch.yml && \
#    sed -i 's/\(^xpack.security.enabled:\) true$/\1 false # DOCKER-STACKS-MOD: disabled security/' /etc/elasticsearch/elasticsearch.yml && \
#    chown ${NB_UID}:${NB_GID} -R /usr/share/elasticsearch /var/log/elasticsearch /var/lib/elasticsearch /etc/default/elasticsearch /etc/elasticsearch && chmod ug+x /etc/default/elasticsearch

COPY custom-start.sh /usr/local/bin/custom-start.sh
COPY jupyterhub_custom_config.py /etc/jupyter/jupyterhub_custom_config.py
# to put the examples in the image, copy them here: run: `cp ../examples .` before building the image
#COPY --chown=${NB_USER}:users examples /home/${NB_USER}/examples
CMD ["custom-start.sh"]

USER ${NB_UID}
