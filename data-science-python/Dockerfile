# Start from a core stack version
FROM jupyter/pyspark-notebook:latest

# environmental variables
ENV JUPYTER_ALLOW_INSECURE_WRITES=true

# additinal ubuntu packages:
USER root
RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends libblas3 liblapack3 libstdc++6 \
    python-setuptools graphviz python3-pydot openssh-server telnet iputils-ping && \ 
    ## temporary fix for https://github.com/ztane/python-Levenshtein/issues/46 : 
    # python3-dev libxslt-dev libffi-dev libssl-dev& & \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* 

# additional python packages (with the default user of pyspark-notebook):
# USER $NB_UID

# update pip (required for eg. turicreate), then install additional packages in one round (reducing image size)
#RUN pip install --upgrade setuptools pip wheel \
#    # sparkmonitor fix: https://github.com/krishnan-r/sparkmonitor/issues/16 
#    # sparkmonitor-s==0.0.11 \
#    # sparkmonitor \ # removed because it never worked, and makes pip downgrade jupyterlab 3 to 2
#    # TODO: use https://github.com/swan-cern/jupyter-extensions/tree/master/SparkMonitor 
#    twython scrapy nltk xmltodict graphviz pydotplus psycopg2-binary google-cloud-bigquery \
#    itables \
#    # compress_pickle only works with pip, not conda
#    compress_pickle \
#    xgboost tensorflow chainer pymongo
#    # xgboost keras chainer pymongo # new recommendation: install keras as part of tensorflow
    # karateclub does not compile with python 3.9 (building python-levenshtein dependency fails)
    # might be fixed, did not work at first: https://linuxtect.com/the-error-command-gcc-failed-with-exit-status-1-error-and-solution
    # karateclub
    # pip install jupyterlab_latex \
#    && \ # does not work with newest pip (~22), setup.py: "Multiple top-level modules discovered in a flat-layout"
#    pip install -e 'git+https://github.com/SohierDane/BigQuery_Helper#egg=bq_helper'

# turicreate did not work with python 3.8, but it does now; however, there is a version problem with llvmlite
# now does not work with 3.9 
# RUN pip install turicreate --ignore-installed llvmlite

# update conda (no longer needed, it is updated in one of the FROM images), then install all packages in one round:
# TODO: consider using nomkl to reduce image size again
# TODO: conda config --set channel_priority strict might be required
# RUN mamba update conda
# install with pip instead of conda: (tensorflow does not work if we try to install with conda) TODO: check this again with keras.tensorflow
#    conda install --yes --quiet \
#    tensorflow keras \
#    pymongo \
#    geopandas && \
RUN mamba install -v --yes --quiet --channel conda-forge \
    twython scrapy nltk xmltodict graphviz pydotplus psycopg2-binary google-cloud-bigquery \
    itables \
    # compress_pickle only works with pip, not conda
    compress-pickle \
    xgboost tensorflow chainer pymongo \
    bqplot \
    hdbscan \
    alpenglow \
    cufflinks-py \
    elasticsearch \
    pyod \
    pyproj \
    geopandas \
    geopy \
    rasterio \
    wfdb \
    blas \
    clickhouse-driver \
    folium \
    jupyter_contrib_nbextensions \
    jupyter_nbextensions_configurator \
    jupyter_bokeh \
    jupyter-lsp-python \
    jupyterlab-geojson \
    jupyterlab-lsp \
    retrolab \
    # jupyterlab-git \ # removed because it created conda conflicts with jupyterlab 3
    # qgrid \ # latest 1.3.1 is too old, needs ipywidgets~=7, which does not work with the newest jupyter
    gpxpy \
    catboost \
    shap \
    plotly \
    polars \
    vaex \
    openpyxl \
    asammdf[gui] && \
    # cleanup
# install and enable Jupyter / JupyterLab extensions:
    jupyter contrib nbextension install --sys-prefix && \
    jupyter nbextension enable collapsible_headings/main --sys-prefix && \
    jupyter nbextension enable toc2/main --sys-prefix && \
    mamba clean --all -f -y && \
    npm cache clean --force && \
    #jupyter nbextension enable --py --sys-prefix qgrid && \ # removed, see conda
    #jupyter serverextension enable --py --sys-prefix jupyterlab_git && \ # removed, see conda
    #jupyter nbextension install sparkmonitor --py --sys-prefix --symlink  && \ # removed, see pip
    #jupyter nbextension enable sparkmonitor --py --sys-prefix && \ # removed, see pip
    #jupyter serverextension enable --py --sys-prefix sparkmonitor && \ # removed, see pip
    #ipython profile create && echo "c.InteractiveShellApp.extensions.append('sparkmonitor.kernelextension')" >>  $(ipython profile locate default)/ipython_kernel_config.py && \ # removed, see pip
    #jupyter labextension install @jupyterlab/git --no-build && \ # removed, see conda
    #jupyter labextension install @jupyterlab/geojson-extension --no-build && \ # only conda install jupyterlab-geojson is needed in JupyterLab 3
#deprecated:    jupyter labextension install @jupyterlab/plotly-extension --no-build && \
    #jupyter labextension install jupyterlab-plotly --no-build && \ # only conda install plotly is needed in JupyterLab 3
    #jupyter labextension install @jupyterlab/vega2-extension --no-build && \ # new version included in JupyterLab 3
#does not work with Jupyterlab 2:    jupyter labextension install beakerx-jupyterlab --no-build && \
    #jupyter labextension install qgrid2 --no-build && \ # does not work with jupyterlab 3, using @j123npm fork:
    #jupyter labextension install @j123npm/qgrid2 --no-build && \ # no longer works in newer JupyterLab 3
    #jupyter labextension install @krassowski/jupyterlab_go_to_definition --no-build && \ # abandoned, using jupyterlab-lsp instead (see conda install)
#deprecated:   jupyter labextension install jupyterlab_bokeh --no-build && \
    #jupyter labextension install @bokeh/jupyter_bokeh --no-build && \ # only conda install bokeh is needed in jupyterlab 3
    #jupyter labextension install bqplot --no-build && \ # only conda install bqplot is needed in JupyterLab 3
    #jupyter labextension install @mflevine/jupyterlab_html --no-build && \
    #jupyter labextension install @jupyterlab/fasta-extension --no-build && \
    #jupyter labextension install @jupyterlab/latex --no-build && \
    #jupyter serverextension enable --sys-prefix jupyterlab_latex && \
    #jupyter labextension install @jupyterlab/github --no-build && \
    #jupyter labextension install @jupyterlab/google-drive --no-build && \
    #jupyter labextension install jupyterlab-kernelspy --no-build && \
    #jupyter labextension install knowledgelab --no-build && \
    #jupyter labextension install jupyterlab-drawio --no-build && \
    # build and cleanup:
#    jupyter lab build -y && \ # no longer works but also no longer needed for jupyterlab
    jupyter lab clean -y && \
    rm -rf ${CONDA_DIR}/share/jupyter/lab/staging && \
    npm cache clean --force && \
    rm -rf /home/${NB_USER}/.cache/yarn && \
    fix-permissions ${CONDA_DIR} && \
    fix-permissions /home/${NB_USER}

# install ElasticSearch
RUN wget --progress=dot:giga https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.17.9-amd64.deb && \
    wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.17.9-amd64.deb.sha512 && \
    shasum -a 512 -c elasticsearch-7.17.9-amd64.deb.sha512 && \
    dpkg -i elasticsearch-7.17.9-amd64.deb && \
    rm elasticsearch-7.17.9-amd64.deb && \
    rm elasticsearch-7.17.9-amd64.deb.sha512 && \
    update-rc.d elasticsearch defaults 95 10
# ElasticSearch 8 has no support for sysvinit service management, only systemctl, which does not work in containers
#RUN wget --progress=dot:giga https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.6.2-amd64.deb && \
#    wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.6.2-amd64.deb.sha512 && \
#    shasum -a 512 -c elasticsearch-8.6.2-amd64.deb.sha512 && \
#    dpkg -i elasticsearch-8.6.2-amd64.deb && \
#    rm elasticsearch-8.6.2-amd64.deb && \
#    rm elasticsearch-8.6.2-amd64.deb.sha512

COPY custom-start.sh /usr/local/bin/custom-start.sh
COPY --chown=${NB_USER}:users jupyterhub_custom_config.py /home/${NB_USER}/jupyterhub_custom_config.py
CMD ["custom-start.sh"]

USER ${NB_UID}
#RUN fix-permissions ${CONDA_DIR} && \
#    fix-permissions /home/${NB_USER}
