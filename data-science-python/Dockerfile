# Start from a core stack version
FROM jupyter/pyspark-notebook:aec555e49be6

# environmental variables
ENV JUPYTER_ALLOW_INSECURE_WRITES=true

# additinal ubuntu packages:
USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends libblas3 liblapack3 libstdc++6 \
    python-setuptools graphviz python3-pydot python3-pydot-ng openssh-server telnet iputils-ping && \
    rm -rf /var/lib/apt/lists/* 

# additional python packages (with the default user of pyspark-notebook):
# USER $NB_UID

# update pip (required for eg. turicreate), then install additional packages in one round (reducing image size)
RUN pip install --upgrade setuptools pip wheel \
    # sparkmonitor fix: https://github.com/krishnan-r/sparkmonitor/issues/16 
    # sparkmonitor-s==0.0.11 \
    sparkmonitor \
    twython scrapy nltk xmltodict graphviz pydotplus psycopg2-binary google-cloud-bigquery \
    itables \
    # compress_pickle only works with pip, not conda
    compress_pickle \
    xgboost keras pymongo karateclub chainer \
    # geopandas bug - see https://github.com/geopandas/geopandas/issues/1113
    # pyproj==2.3.1 && \ # using conda instead with version 2.6.0, then with 3.0.0
    # geopandas && \
    # pip install jupyterlab_latex && \
    pip install -e git+https://github.com/SohierDane/BigQuery_Helper#egg=bq_helper

# turicreate did not work with python 3.8, but it does now; however, there is a version problem with llvmlite
RUN pip install turicreate --ignore-installed llvmlite

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
    wfdb \
    clickhouse-driver \
    folium \
    jupyter_contrib_nbextensions \
    jupyter_nbextensions_configurator \
    # ipywidgets \  # installed in scipy-notebook
    jupyterlab-git \
    qgrid \
    gpxpy && \
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
    jupyter serverextension enable --py --sys-prefix jupyterlab_git && \
    jupyter nbextension install sparkmonitor --py --sys-prefix --symlink  && \
    jupyter nbextension enable sparkmonitor --py --sys-prefix && \
    jupyter serverextension enable --py --sys-prefix sparkmonitor && \
    ipython profile create && echo "c.InteractiveShellApp.extensions.append('sparkmonitor.kernelextension')" >>  $(ipython profile locate default)/ipython_kernel_config.py && \
    jupyter labextension install @jupyterlab/git --no-build && \
    jupyter labextension install @jupyterlab/geojson-extension --no-build && \
#deprecated:    jupyter labextension install @jupyterlab/plotly-extension --no-build && \
    jupyter labextension install jupyterlab-plotly@4.8.1 --no-build && \
    jupyter labextension install @jupyterlab/vega2-extension --no-build && \
#does not work with Jupyterlab 2:    jupyter labextension install beakerx-jupyterlab --no-build && \
    jupyter labextension install qgrid --no-build && \
    jupyter labextension install @krassowski/jupyterlab_go_to_definition --no-build && \
#deprecated:   jupyter labextension install jupyterlab_bokeh --no-build && \
    jupyter labextension install @bokeh/jupyter_bokeh --no-build && \
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
