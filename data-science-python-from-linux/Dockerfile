# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

# Ubuntu 20.04 (focal)
# https://hub.docker.com/_/ubuntu/?tab=tags&name=focal
# OS/ARCH: linux/amd64
ARG ROOT_CONTAINER=ubuntu:focal-20200606@sha256:93fd0705706e5bdda6cc450b384d8d5afb18fecc19e054fe3d7a2c8c2aeb2c83
ARG BASE_CONTAINER=$ROOT_CONTAINER
FROM $BASE_CONTAINER

LABEL maintainer="Jupyter Project <jupyter@googlegroups.com>"
ARG NB_USER="jovyan"
ARG NB_UID="1000"
ARG NB_GID="100"

USER root

# Install all OS dependencies for notebook server that starts but lacks all
# features (e.g., download as all possible file formats)
ENV DEBIAN_FRONTEND noninteractive
# Configure environment
ENV CONDA_DIR=/opt/conda \
    SHELL=/bin/bash \
    NB_USER=$NB_USER \
    NB_UID=$NB_UID \
    NB_GID=$NB_GID \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8
ENV PATH=$CONDA_DIR/bin:$PATH \
    HOME=/home/$NB_USER
# ==> scipy-notebook (https://hub.docker.com/r/jupyter/scipy-notebook/dockerfile)
ENV XDG_CACHE_HOME /home/$NB_USER/.cache/
# <== scipy-notebook (https://hub.docker.com/r/jupyter/scipy-notebook/dockerfile)
# ==> pyspark-notebook (https://hub.docker.com/r/jupyter/pyspark-notebook/dockerfile)
ENV APACHE_SPARK_VERSION=2.4.5 \
    HADOOP_VERSION=2.7
# <== pyspark-notebook (https://hub.docker.com/r/jupyter/pyspark-notebook/dockerfile)
# ==> pyspark-notebook (https://hub.docker.com/r/jupyter/pyspark-notebook/dockerfile)
# Configure Spark
ENV SPARK_HOME=/usr/local/spark
ENV PYTHONPATH=$SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.7-src.zip \
    SPARK_OPTS="--driver-java-options=-Xms1024M --driver-java-options=-Xmx4096M --driver-java-options=-Dlog4j.logLevel=info" \
    PATH=$PATH:$SPARK_HOME/bin
# <== pyspark-notebook (https://hub.docker.com/r/jupyter/pyspark-notebook/dockerfile)
# Install conda as jovyan and check the md5 sum provided on the download site
ENV MINICONDA_VERSION=4.8.3 \
    MINICONDA_MD5=751786b92c00b1aeae3f017b781018df \
    CONDA_VERSION=4.8.3
ENV MINICONDA_SETUP_FILENAME="Miniconda3-py37_"${MINICONDA_VERSION}"-Linux-x86_64.sh"
ENV MINICONDA_SETUP_URL="https://repo.anaconda.com/miniconda/"${MINICONDA_SETUP_FILENAME}

# Copy a script that we will use to correct permissions after running certain commands
COPY build-files/fix-permissions /usr/local/bin/fix-permissions
# Copy local files as late as possible to avoid cache busting
COPY build-files/start.sh build-files/start-notebook.sh build-files/start-singleuser.sh /usr/local/bin/
COPY build-files/jupyter_notebook_config.py /etc/jupyter/

RUN apt-get -y update \
 && apt-get install -yq --no-install-recommends locales \
 && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen \
 && apt-get install -yq --no-install-recommends \
    wget \
    bzip2 \
    ca-certificates \
    sudo \
    fonts-liberation \
    run-one \
# ==> minimal-notebook (https://hub.docker.com/r/jupyter/minimal-notebook/dockerfile)
    build-essential \
    emacs-nox \
    vim-tiny \
    git \
    inkscape \
    jed \
    libsm6 \
    libxext-dev \
    libxrender1 \
    lmodern \
    netcat \
    python-dev \
    # ---- nbconvert dependencies ----
    texlive-xetex \
    texlive-fonts-recommended \
    # not in 20.04: texlive-generic-recommended \
    texlive-plain-generic \
    # Optional dependency
    texlive-fonts-extra \
    # ----
    tzdata \
    unzip \
    nano \
# <== minimal-notebook (https://hub.docker.com/r/jupyter/minimal-notebook/dockerfile)
# ==> scipy-notebook (https://hub.docker.com/r/jupyter/scipy-notebook/dockerfile)
    ffmpeg \
    dvipng \
# <== scipy-notebook (https://hub.docker.com/r/jupyter/scipy-notebook/dockerfile)
# ==> pyspark-notebook (https://hub.docker.com/r/jupyter/pyspark-notebook/dockerfile)
    openjdk-8-jre-headless \
    ca-certificates-java \
# <== pyspark-notebook (https://hub.docker.com/r/jupyter/pyspark-notebook/dockerfile)
# ==> data-science-python (https://hub.docker.com/r/sidlo/data-science-python/dockerfile)
    libblas3 \
    liblapack3 \
    libstdc++6 \
    python-setuptools \
    graphviz \
    # not in 20.04: python-pydot \
    # not in 20.04: python-pydot-ng \
    python3-pydot \
    python3-pydot-ng \
    openssh-server \
    telnet \
    iputils-ping \
# <== data-science-python (https://hub.docker.com/r/sidlo/data-science-python/dockerfile)
 && apt-get clean && rm -rf /var/lib/apt/lists/* \
\
# ==> pyspark-notebook (https://hub.docker.com/r/jupyter/pyspark-notebook/dockerfile)
# Using the preferred mirror to download the file
 && cd /tmp && \
    wget -q $(wget -qO- https://www.apache.org/dyn/closer.lua/spark/spark-${APACHE_SPARK_VERSION}/spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz\?as_json | \
    python -c "import sys, json; content=json.load(sys.stdin); print(content['preferred']+content['path_info'])") && \
    echo "2426a20c548bdfc07df288cd1d18d1da6b3189d0b78dee76fa034c52a4e02895f0ad460720c526f163ba63a17efae4764c46a1cd8f9b04c60f9937a554db85d2 *spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz" | sha512sum -c - && \
    tar xzf spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz -C /usr/local --owner root --group root --no-same-owner && \
    rm spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    cd /usr/local && ln -s spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} spark \
# <== pyspark-notebook (https://hub.docker.com/r/jupyter/pyspark-notebook/dockerfile)
\
 && chmod a+rx /usr/local/bin/fix-permissions \
\
# Enable prompt color in the skeleton .bashrc before creating the default NB_USER
 && sed -i 's/^#force_color_prompt=yes/force_color_prompt=yes/' /etc/skel/.bashrc \
\
# Create NB_USER wtih name jovyan user with UID=1000 and in the 'users' group
# and make sure these dirs are writable by the `users` group.
 && echo "auth requisite pam_deny.so" >> /etc/pam.d/su && \
    sed -i.bak -e 's/^%admin/#%admin/' /etc/sudoers && \
    sed -i.bak -e 's/^%sudo/#%sudo/' /etc/sudoers && \
    useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
    mkdir -p $CONDA_DIR && \
    chown $NB_USER:$NB_GID $CONDA_DIR && \
    chmod g+w /etc/passwd && \
    fix-permissions $HOME && \
    fix-permissions $CONDA_DIR

USER $NB_UID
WORKDIR $HOME
ARG PYTHON_VERSION=default

# Setup work directory for backward-compatibility
RUN mkdir /home/$NB_USER/work && \
    fix-permissions /home/$NB_USER \
\
 && cd /tmp && \
    wget --quiet "${MINICONDA_SETUP_URL}" && \
    echo "${MINICONDA_MD5} *${MINICONDA_SETUP_FILENAME}" | md5sum -c - && \
    /bin/bash "${MINICONDA_SETUP_FILENAME}" -f -b -p $CONDA_DIR && \
    rm "${MINICONDA_SETUP_FILENAME}" && \
    echo "conda ${CONDA_VERSION}" >> $CONDA_DIR/conda-meta/pinned && \
    conda config --system --prepend channels conda-forge && \
    conda config --system --set auto_update_conda false && \
    conda config --system --set show_channel_urls true && \
    conda config --system --set channel_priority strict && \
    if [ ! $PYTHON_VERSION = 'default' ]; then conda install --yes python=$PYTHON_VERSION; fi && \
    conda list python | grep '^python ' | tr -s ' ' | cut -d '.' -f 1,2 | sed 's/$/.*/' >> $CONDA_DIR/conda-meta/pinned && \
    conda install --quiet --yes conda && \
    conda install --quiet --yes pip && \
    conda update --all --quiet --yes && \
    conda clean --all -f -y && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER \
\
# ==> data-science-python (https://hub.docker.com/r/sidlo/data-science-python/dockerfile)
# update pip (required for eg. turicreate), then install additional packages in one round (reducing image size)
 && pip install --upgrade setuptools pip wheel \
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
    pip install -e git+https://github.com/SohierDane/BigQuery_Helper#egg=bq_helper \
# <== data-science-python (https://hub.docker.com/r/sidlo/data-science-python/dockerfile)
\
# Install Tini
 && conda install --quiet --yes 'tini=0.18.0' && \
    conda list tini | grep tini | tr -s ' ' | cut -d ' ' -f 1,2 >> $CONDA_DIR/conda-meta/pinned && \
    conda clean --all -f -y && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER \
\
# Install Jupyter Notebook, Lab, and Hub
# Generate a notebook server config
# Cleanup temporary files
# Correct permissions
# Do all this in a single RUN command to avoid duplicating all of the
# files across image layers when the permissions change
 && conda install --quiet --yes \
    'notebook=6.0.3' \
    'jupyterhub=1.1.0' \
    'jupyterlab=2.1.3' \
# ==> scipy-notebook (https://hub.docker.com/r/jupyter/scipy-notebook/dockerfile)
    'beautifulsoup4=4.9.*' \
    'conda-forge::blas=*=openblas' \
    'bokeh=2.0.*' \
    'bottleneck=1.3.*' \
    'cloudpickle=1.4.*' \
    'cython=0.29.*' \
    'dask=2.15.*' \
    'dill=0.3.*' \
    'h5py=2.10.*' \
    'hdf5=1.10.*' \
    'ipywidgets=7.5.*' \
    'ipympl=0.5.*'\
    'matplotlib-base=3.2.*' \
    # numba update to 0.49 fails resolving deps.
    'numba=0.48.*' \
    'numexpr=2.7.*' \
    'pandas=1.0.*' \
    'patsy=0.5.*' \
    'protobuf=3.11.*' \
    'pytables=3.6.*' \
    'scikit-image=0.16.*' \
    'scikit-learn=0.22.*' \
    'scipy=1.4.*' \
    'seaborn=0.10.*' \
    'sqlalchemy=1.3.*' \
    'statsmodels=0.11.*' \
    'sympy=1.5.*' \
    'vincent=0.4.*' \
    'widgetsnbextension=3.5.*'\
    'xlrd=1.2.*' \
# <== scipy-notebook (https://hub.docker.com/r/jupyter/scipy-notebook/dockerfile)
# ==> pyspark-notebook (https://hub.docker.com/r/jupyter/pyspark-notebook/dockerfile)
# too old, we rather install it with pip
#    'pyarrow=0.14.1' \
# <== pyspark-notebook (https://hub.docker.com/r/jupyter/pyspark-notebook/dockerfile)
# ==> data-science-python (https://hub.docker.com/r/sidlo/data-science-python/dockerfile)
# install with pip instead of conda: (tensorflow does not work if we try to install with conda)
#RUN conda install --yes --quiet \
#    tensorflow keras \
#    pymongo \
#    geopandas && \
\
    # conda-forge: 
 && conda install --yes --quiet --channel conda-forge \
    'hdbscan' \
    'alpenglow' \
    'cufflinks-py' \
    'elasticsearch' \
    'geopandas' \
    'geopy' \
    'wfdb' \
    'clickhouse-driver' \
    'folium' \
    'jupyter_contrib_nbextensions' \
    'jupyter_nbextensions_configurator' \
    # ipywidgets \  # installed in scipy-notebook
    'jupyterlab-git' \
    'qgrid' \
    'findspark' \
\
    # other: 
 && conda install --yes --quiet --channel plotly 'plotly' && \
# <== data-science-python (https://hub.docker.com/r/sidlo/data-science-python/dockerfile)
    conda clean --all -f -y && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# ==> custom (moving generate-config upper, so it is generated before labextension commands)
RUN jupyter notebook --generate-config && \
# <== custom (moving generate-config upper, so it is generated before labextension commands)
# ==> data-science-python (https://hub.docker.com/r/sidlo/data-science-python/dockerfile)
    jupyter contrib nbextension install --sys-prefix && \
    jupyter nbextension enable collapsible_headings/main --sys-prefix && \
    jupyter nbextension enable toc2/main --sys-prefix && \
    jupyter nbextension enable --py --sys-prefix qgrid && \
    jupyter serverextension enable --py --sys-prefix jupyterlab_git && \
    jupyter nbextension install sparkmonitor --py --sys-prefix --symlink  && \
    jupyter nbextension enable sparkmonitor --py --sys-prefix && \
    jupyter serverextension enable --py --sys-prefix sparkmonitor && \
# <== data-science-python (https://hub.docker.com/r/sidlo/data-science-python/dockerfile)
# ==> scipy-notebook (https://hub.docker.com/r/jupyter/scipy-notebook/dockerfile)
    jupyter nbextension enable --py widgetsnbextension --sys-prefix && \
# <== scipy-notebook (https://hub.docker.com/r/jupyter/scipy-notebook/dockerfile)
# ==> data-science-python (https://hub.docker.com/r/sidlo/data-science-python/dockerfile)
    ipython profile create && echo "c.InteractiveShellApp.extensions.append('sparkmonitor.kernelextension')" >>  $(ipython profile locate default)/ipython_kernel_config.py && \
# <== data-science-python (https://hub.docker.com/r/sidlo/data-science-python/dockerfile)
# ==> scipy-notebook (https://hub.docker.com/r/jupyter/scipy-notebook/dockerfile)
    # Also activate ipywidgets extension for JupyterLab
    # Check this URL for most recent compatibilities
    # https://github.com/jupyter-widgets/ipywidgets/tree/master/packages/jupyterlab-manager
    jupyter labextension install @jupyter-widgets/jupyterlab-manager@^2.0.0 --no-build && \
    jupyter labextension install @bokeh/jupyter_bokeh@^2.0.0 --no-build && \
    jupyter labextension install jupyter-matplotlib@^0.7.2 --no-build && \
# <== scipy-notebook (https://hub.docker.com/r/jupyter/scipy-notebook/dockerfile)
# ==> data-science-python (https://hub.docker.com/r/sidlo/data-science-python/dockerfile)
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
# <== data-science-python (https://hub.docker.com/r/sidlo/data-science-python/dockerfile)
# ==> scipy-notebook (https://hub.docker.com/r/jupyter/scipy-notebook/dockerfile)
    jupyter lab build -y && \
    jupyter lab clean -y && \
# <== scipy-notebook (https://hub.docker.com/r/jupyter/scipy-notebook/dockerfile)
    npm cache clean --force && \
# ==> custom (moving generate-config upper, so it is generated before labextension commands)
    # jupyter notebook --generate-config && \
# <== custom (moving generate-config upper, so it is generated before labextension commands)
    rm -rf $CONDA_DIR/share/jupyter/lab/staging && \
# ==> scipy-notebook (https://hub.docker.com/r/jupyter/scipy-notebook/dockerfile)
    npm cache clean --force && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    rm -rf /home/$NB_USER/.node-gyp && \
# Install facets which does not have a pip or conda package at the moment
    cd /tmp && \
    git clone https://github.com/PAIR-code/facets.git && \
    cd facets && \
    jupyter nbextension install facets-dist/ --sys-prefix && \
    cd && \
    rm -rf /tmp/facets && \
    MPLBACKEND=Agg python -c "import matplotlib.pyplot" && \
# <== scipy-notebook (https://hub.docker.com/r/jupyter/scipy-notebook/dockerfile)
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

EXPOSE 8888

# Configure container startup
ENTRYPOINT ["tini", "-g", "--"]
CMD ["start-notebook.sh"]

# Fix permissions on /etc/jupyter as root
USER root
RUN fix-permissions /etc/jupyter/

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID
RUN fix-permissions /home/$NB_USER