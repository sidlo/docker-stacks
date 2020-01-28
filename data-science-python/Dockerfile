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
    xgboost && \
    # pip install jupyterlab_latex && \
    pip install -e git+https://github.com/SohierDane/BigQuery_Helper#egg=bq_helper

# update conda, then install all packages in one round:
# conda update -n base conda # updating conda doesn't seems to be unnecessary
# TODO: consider using nomkl to reduce image size again
RUN conda install --yes --quiet \
    tensorflow keras \
    pymongo && \
    # conda-forge: 
    conda install --yes --quiet -c conda-forge \
    hdbscan \
    alpenglow \
    cufflinks-py \
    elasticsearch \
    geopandas \
    geopy \
    wfdb \
    folium \
    jupyter_contrib_nbextensions \
    jupyter_nbextensions_configurator \
    # ipywidgets \  # installed in scipy-notebook
    jupyterlab-git \
    findspark && \
    # other: 
    conda install --yes --quiet -c plotly plotly && \
    # cleanup: 
    conda clean -afy && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# install and enable Jupyter / JupyterLab extensions:
# TODO: check if --dev-build=False is default
RUN jupyter contrib nbextension install --sys-prefix && \
    jupyter nbextension enable collapsible_headings/main --sys-prefix && \
    jupyter nbextension enable toc2/main --sys-prefix && \
    jupyter serverextension enable --py --sys-prefix jupyterlab_git && \
    jupyter nbextension install sparkmonitor --py --sys-prefix --symlink  && \
    jupyter nbextension enable sparkmonitor --py --sys-prefix && \
    jupyter serverextension enable --py --sys-prefix sparkmonitor && \
    ipython profile create && echo "c.InteractiveShellApp.extensions.append('sparkmonitor.kernelextension')" >>  $(ipython profile locate default)/ipython_kernel_config.py && \
    jupyter labextension install @jupyterlab/git && \
    jupyter labextension install @jupyterlab/geojson-extension && \
    jupyter labextension install @jupyterlab/plotly-extension && \
    jupyter labextension install @jupyterlab/vega2-extension && \
    jupyter labextension install beakerx-jupyterlab && \
    jupyter labextension install qgrid && \
    jupyter labextension install @krassowski/jupyterlab_go_to_definition && \
    jupyter labextension install @mflevine/jupyterlab_html && \
    jupyter labextension install jupyterlab_bokeh && \
    jupyter labextension install bqplot  && \
    #jupyter labextension install @jupyterlab/fasta-extension && \
    #jupyter labextension install @jupyterlab/latex && \
    #jupyter serverextension enable --sys-prefix jupyterlab_latex && \
    #jupyter labextension install @jupyterlab/github && \
    #jupyter labextension install @jupyterlab/google-drive && \
    #jupyter labextension install jupyterlab-kernelspy && \
    #jupyter labextension install knowledgelab && \
    #jupyter labextension install jupyterlab-drawio && \
    rm -rf $CONDA_DIR/share/jupyter/lab/staging && \
    npm cache clean --force && \
    fix-permissions /home/$NB_USER

# cleanup:
#RUN npm cache clean --force && \
#    rm -rf $CONDA_DIR/share/jupyter/lab/staging && \
#    rm -rf /home/$NB_USER/.cache/yarn && \
#RUN fix-permissions $CONDA_DIR && \
#    fix-permissions /home/$NB_USER

USER $NB_USER