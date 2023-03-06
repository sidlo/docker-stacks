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
    xgboost tensorflow chainer pymongo
    # xgboost keras chainer pymongo # new recommendation: install keras as part of tensorflow
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

# RUN conda update conda
RUN conda update conda && \
    conda install conda-libmamba-solver && \
    conda config --set solver libmamba && \
# install with pip instead of conda: (tensorflow does not work if we try to install with conda) TODO: check this again with keras.tensorflow
#    conda install --yes --quiet \
#    tensorflow keras \
#    pymongo \
#    geopandas && \
    conda install --yes --quiet --channel conda-forge \
#    pandas==2.0.0rc0 \ # not yet available 2023.03.01
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
# blas version has to have a lower bound to avoid version downgrades
    "blas>=2" \
    clickhouse-driver \
    folium \
    jupyter_contrib_nbextensions \
    jupyter_nbextensions_configurator \
    jupyter_bokeh \
    jupyter-lsp-python \
    jupyterlab-geojson \
    jupyterlab-lsp \
    # "retrolab>=0.3.21" \ # adding retrolab here made the install take hours, even with version constraint, moved to a new install command below
    # jupyterlab-git \ # removed because it created conda conflicts with jupyterlab 3
    # qgrid \ # latest 1.3.1 is too old, needs ipywidgets~=7, which does not work with the newest jupyter
    gpxpy \
    catboost \
    shap \
    plotly && \
# this took much more time when running in the same install with the others, installs quick if put in another command:
    conda install --yes --quiet --channel conda-forge retrolab && \
    # cleanup
    conda clean -afy && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER
# tried out these version constraints to make solving faster, but in the end only "blas>=2" was needed
#    "jupyter_client>=8" "jupyter_server>=2.3" "jupyterlab_server>=2.15" "jupyterlab>=3.6" "wfdb>=4" "blas>=2" "notebook>=6" "ipython>=8" "nbclassic>=0.4" "jupyter-lsp-python>=1.5" "jupyterlab-lsp>=3.10" \

# install and enable Jupyter / JupyterLab extensions:
# TODO: check if --dev-build=False is default
RUN jupyter contrib nbextension install --sys-prefix && \
    jupyter nbextension enable collapsible_headings/main --sys-prefix && \
    jupyter nbextension enable toc2/main --sys-prefix && \
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
    rm -rf $CONDA_DIR/share/jupyter/lab/staging && \
    npm cache clean --force && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    fix-permissions /home/$NB_USER

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
COPY --chown=$NB_USER:users jupyterhub_custom_config.py /home/$NB_USER/jupyterhub_custom_config.py
CMD ["custom-start.sh"]

USER $NB_USER
RUN fix-permissions /home/$NB_USER
