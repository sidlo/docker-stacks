# Start from a core stack version
FROM jupyter/pyspark-notebook:latest

# environmental variables
ENV JUPYTER_ALLOW_INSECURE_WRITES=true

# additinal ubuntu packages:
USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends libblas3 liblapack3 libstdc++6 \
    python-setuptools graphviz python3-pydot openssh-server telnet iputils-ping && \ 
    ## temporary fix for https://github.com/ztane/python-Levenshtein/issues/46 : 
    # python3-dev libxslt-dev libffi-dev libssl-dev& & \
    rm -rf /var/lib/apt/lists/* 

# additional python packages (with the default user of pyspark-notebook):
# USER $NB_UID

# update pip (required for eg. turicreate), then install additional packages in one round (reducing image size)
RUN pip install --upgrade setuptools pip wheel \
    # sparkmonitor fix: https://github.com/krishnan-r/sparkmonitor/issues/16 
    # sparkmonitor-s==0.0.11 \
    # sparkmonitor \ # removed because it never worked, and makes pip downgrade jupyterlab 3 to 2
    # TODO: use https://github.com/swan-cern/jupyter-extensions/tree/master/SparkMonitor 
    twython scrapy nltk xmltodict graphviz pydotplus psycopg2-binary google-cloud-bigquery \
    itables \
    # compress_pickle only works with pip, not conda
    compress_pickle \
    xgboost keras chainer pymongo
    # karateclub does not compile with python 3.9 (building python-levenshtein dependency fails)
    # might be fixed, did not work at first: https://linuxtect.com/the-error-command-gcc-failed-with-exit-status-1-error-and-solution
    # karateclub
    # pip install jupyterlab_latex \
#    && \ # does not work with newest pip (~22), setup.py: "Multiple top-level modules discovered in a flat-layout"
#    pip install -e 'git+https://github.com/SohierDane/BigQuery_Helper#egg=bq_helper'

# turicreate did not work with python 3.8, but it does now; however, there is a version problem with llvmlite
# now does not work with 3.9 
# RUN pip install turicreate --ignore-installed llvmlite

# update conda, then install all packages in one round:
# conda update -n base conda # updating conda doesn't seems to be unnecessary
# TODO: consider using nomkl to reduce image size again
# TODO: conda config --set channel_priority strict might be required

# install with pip instead of conda: (tensorflow does not work if we try to install with conda)
#RUN conda install --yes --quiet \
#    tensorflow keras \
#    pymongo \
#    geopandas && \
RUN conda install --yes --quiet --channel conda-forge \
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
    clickhouse-driver \
    folium \
    jupyter_contrib_nbextensions \
    jupyter_nbextensions_configurator \
    jupyter_bokeh \
    # ipywidgets \ # ipywidgets 8 is not yet compatible with qgrid
    ipywidgets~=7.0 \
    # ipywidgets \  # installed in scipy-notebook
    # jupyterlab-git \ # removed because it created conda conflicts with jupyterlab 3
    qgrid \
    gpxpy \
    catboost shap && \
    # other: 
    conda install --yes --quiet --channel plotly plotly && \
    # cleanup: 
    conda clean -afy && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# install and enable Jupyter / JupyterLab extensions:
# TODO: check if --dev-build=False is default
RUN jupyter contrib nbextension install --sys-prefix && \
    jupyter nbextension enable collapsible_headings/main --sys-prefix && \
    jupyter nbextension enable toc2/main --sys-prefix && \
    jupyter nbextension enable --py --sys-prefix qgrid && \
    #jupyter serverextension enable --py --sys-prefix jupyterlab_git && \ # removed, see conda
    #jupyter nbextension install sparkmonitor --py --sys-prefix --symlink  && \ # removed, see pip
    #jupyter nbextension enable sparkmonitor --py --sys-prefix && \ # removed, see pip
    #jupyter serverextension enable --py --sys-prefix sparkmonitor && \ # removed, see pip
    #ipython profile create && echo "c.InteractiveShellApp.extensions.append('sparkmonitor.kernelextension')" >>  $(ipython profile locate default)/ipython_kernel_config.py && \ # removed, see pip
    #jupyter labextension install @jupyterlab/git --no-build && \ # removed, see conda
    jupyter labextension install @jupyterlab/geojson-extension --no-build && \
#deprecated:    jupyter labextension install @jupyterlab/plotly-extension --no-build && \
    jupyter labextension install jupyterlab-plotly --no-build && \
    jupyter labextension install @jupyterlab/vega2-extension --no-build && \
#does not work with Jupyterlab 2:    jupyter labextension install beakerx-jupyterlab --no-build && \
    #jupyter labextension install qgrid2 --no-build && \ # does not work with jupyterlab 3, using @j123npm fork:
    jupyter labextension install @j123npm/qgrid2 --no-build && \
    jupyter labextension install @krassowski/jupyterlab_go_to_definition --no-build && \
#deprecated:   jupyter labextension install jupyterlab_bokeh --no-build && \
    #jupyter labextension install @bokeh/jupyter_bokeh --no-build && \ # only conda install is needed in jupyterlab 3
    jupyter labextension install bqplot --no-build && \
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
    jupyter lab build -y && \
    jupyter lab clean -y && \
    rm -rf $CONDA_DIR/share/jupyter/lab/staging && \
    npm cache clean --force && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    fix-permissions /home/$NB_USER

# install ElasticSearch
RUN wget --progress=dot:giga https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.10.2-amd64.deb && \
    wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.10.2-amd64.deb.sha512 && \
    shasum -a 512 -c elasticsearch-7.10.2-amd64.deb.sha512 && \
    dpkg -i elasticsearch-7.10.2-amd64.deb && \
    rm elasticsearch-7.10.2-amd64.deb && \
    rm elasticsearch-7.10.2-amd64.deb.sha512 && \
    update-rc.d elasticsearch defaults 95 10

COPY custom-start.sh /usr/local/bin/custom-start.sh
COPY --chown=$NB_USER:users jupyterhub_custom_config.py /home/$NB_USER/jupyterhub_custom_config.py
CMD ["custom-start.sh"]

USER $NB_USER
RUN fix-permissions /home/$NB_USER
