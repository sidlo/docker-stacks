# Start from a core stack version
FROM jupyter/pyspark-notebook:latest

# additinal ubuntu packages:
USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends libblas3 liblapack3 libstdc++6 \
    python-setuptools graphviz python-pydot python-pydot-ng openssh-server telnet iputils-ping && \
    rm -rf /var/lib/apt/lists/* 

# additional python packages (with the default user of pyspark-notebook):
# USER $NB_UID

# update pip (required for eg. turicreate), then install additional packages in one round (reducing image size)
RUN pip install --upgrade setuptools pip wheel \
    # sparkmonitor fix: https://github.com/krishnan-r/sparkmonitor/issues/16 
    sparkmonitor-s==0.0.11 \
    #sparkmonitor \
    # turicreate works now with python 3.7 support:
    turicreate \
    twython scrapy nltk xmltodict graphviz pydotplus psycopg2-binary google-cloud-bigquery \
    # pyarrow with spark currently only works with pip install, not the conda version, and only below v0.15
    pyarrow==0.14.1 \
    # compress_pickle only works with pip, not conda
    compress_pickle \
    xgboost \
    keras pymongo geopandas && \
    # geopandas bug - see https://github.com/geopandas/geopandas/issues/1113
    # pyproj==2.3.1 && \
    # pip install jupyterlab_latex && \
    pip install -e git+https://github.com/SohierDane/BigQuery_Helper#egg=bq_helper

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
    findspark && \
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
    jupyter labextension install @jupyterlab/git && \
    jupyter labextension install @jupyterlab/geojson-extension && \
#deprecated:    jupyter labextension install @jupyterlab/plotly-extension && \
    jupyter labextension install jupyterlab-plotly@4.8.1 && \
    jupyter labextension install @jupyterlab/vega2-extension && \
#does not work with Jupyterlab 2:    jupyter labextension install beakerx-jupyterlab && \
    jupyter labextension install qgrid && \
    jupyter labextension install @krassowski/jupyterlab_go_to_definition && \
#deprecated:   jupyter labextension install jupyterlab_bokeh && \
    jupyter labextension install @bokeh/jupyter_bokeh && \
    jupyter labextension install bqplot  && \
    #jupyter labextension install @mflevine/jupyterlab_html && \
    #jupyter labextension install @jupyterlab/fasta-extension && \
    #jupyter labextension install @jupyterlab/latex && \
    #jupyter serverextension enable --sys-prefix jupyterlab_latex && \
    #jupyter labextension install @jupyterlab/github && \
    #jupyter labextension install @jupyterlab/google-drive && \
    #jupyter labextension install jupyterlab-kernelspy && \
    #jupyter labextension install knowledgelab && \
    #jupyter labextension install jupyterlab-drawio && \
    # cleanup:
    rm -rf $CONDA_DIR/share/jupyter/lab/staging && \
    npm cache clean --force && \
    fix-permissions /home/$NB_USER

# cleanup:
#RUN rm -rf /home/$NB_USER/.cache/yarn && \

##### experimental
# Spark dependencies
ENV APACHE_SPARK_VERSION=3.0.0-preview2 \
    HADOOP_VERSION=2.7

# Using the preferred mirror to download Spark
WORKDIR /tmp
# hadolint ignore=SC2046
RUN wget -q $(wget -qO- https://www.apache.org/dyn/closer.lua/spark/spark-${APACHE_SPARK_VERSION}/spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz\?as_json | \
    python -c "import sys, json; content=json.load(sys.stdin); print(content['preferred']+content['path_info'])") && \
    tar xzf "spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz" -C /usr/local --owner root --group root --no-same-owner && \
    rm "spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz"

WORKDIR /usr/local
RUN rm spark && ln -s "spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}" spark
WORKDIR /home/$NB_USER
##### end of experimental

#TODO: delete
#RUN fix-permissions $CONDA_DIR && \
#    fix-permissions /home/$NB_USER

USER $NB_USER
RUN fix-permissions /home/$NB_USER
