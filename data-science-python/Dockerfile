# Start from a core stack version
FROM jupyter/pyspark-notebook:latest

# additinal ubuntu packages:
USER root
RUN apt-get update && apt-get install -y libblas3 liblapack3 libstdc++6 \
    python-setuptools graphviz python-pydot python-pydot-ng openssh-server telnet iputils-ping

# additional python packages (with the default user of pyspark-notebook):
# USER $NB_UID

# update pip (required for eg. turicreate) and conda
#RUN pip install -U pip
RUN pip install --upgrade setuptools pip wheel
RUN conda update -n base conda

# avoid mkl to reduce image size
RUN conda install --yes nomkl && conda clean -afy

#RUN pip install findspark
RUN conda install -c conda-forge findspark && conda clean -afy

# Jupyter / JupyterLab extensions:
# nbextensions: 
RUN conda install -c conda-forge jupyter_contrib_nbextensions && \
    #pip install jupyter_nbextensions_configurator && \
    conda install -c conda-forge jupyter_nbextensions_configurator && \
    jupyter contrib nbextension install --sys-prefix && \
    jupyter nbextension enable collapsible_headings/main --sys-prefix && \
    jupyter nbextension enable toc2/main --sys-prefix && \
    # sparkmonitor: 
    pip install sparkmonitor  && \
    # pip install sparkmonitor-s==0.0.11 && \
    jupyter nbextension install sparkmonitor --py --sys-prefix --symlink  && \
    jupyter nbextension enable sparkmonitor --py --sys-prefix && \
    jupyter serverextension enable --py --sys-prefix sparkmonitor && \
    ipython profile create && echo "c.InteractiveShellApp.extensions.append('sparkmonitor.kernelextension')" >>  $(ipython profile locate default)/ipython_kernel_config.py

RUN conda install --quiet --yes --freeze-installed -c conda-forge ipywidgets && \
    conda install -c conda-forge  jupyterlab-git && \
    jupyter serverextension enable --py --sys-prefix jupyterlab_git && \
#    jupyter labextension install @jupyterlab/fasta-extension && \
    jupyter labextension install @jupyterlab/git --dev-build=False && \
    pip install jupyterlab_latex && \
    jupyter serverextension enable --sys-prefix jupyterlab_latex && \
    jupyter labextension install @jupyterlab/latex --dev-build=False && \
    jupyter labextension install @jupyterlab/geojson-extension --dev-build=False && \
    jupyter labextension install @jupyterlab/github --dev-build=False && \
    jupyter labextension install @jupyterlab/plotly-extension --dev-build=False && \
    jupyter labextension install @jupyterlab/vega2-extension --dev-build=False && \
    jupyter labextension install beakerx-jupyterlab --dev-build=False && \
    jupyter labextension install @jupyterlab/toc --dev-build=False && \
#    jupyter labextension install @jupyterlab/google-drive --dev-build=False && \
    jupyter labextension install jupyterlab-kernelspy --dev-build=False && \
    jupyter labextension install qgrid --dev-build=False && \
#    jupyter labextension install knowledgelab && \
    jupyter labextension install jupyterlab-drawio --dev-build=False && \
    jupyter labextension install @krassowski/jupyterlab_go_to_definition --dev-build=False && \
    jupyter labextension install @mflevine/jupyterlab_html --dev-build=False && \
    jupyter labextension install jupyterlab_bokeh --dev-build=False && \
    jupyter labextension install bqplot --dev-build=False && \
    conda clean -afy

# other python libraries
RUN pip install psycopg2-binary && \
    pip install --upgrade google-cloud-bigquery && \
    pip install -e git+https://github.com/SohierDane/BigQuery_Helper#egg=bq_helper

# have to wait for turicreate python 3.7 support:
RUN pip install turicreate

# further ML and data science-related packages: 
RUN pip install twython && \
    # pip install pymongo && \
    pip install scrapy && \
    # pip install elasticsearch && \
    pip install nltk && \
    pip install xmltodict && \
    # pip install folium && \
    #pip install geopandas && \
    #pip install geopy && \
    pip install graphviz && \
    #pip install wfdb && \
    pip install pydotplus &&\
    # pyarrow with spark only works with pip install, not the conda version, and only below v0.15
    pip install pyarrow==0.14.1 &&\
    pip install xgboost 

# further ML and deep learning packages:
RUN conda install --yes --quiet --freeze-installed -c plotly plotly \
    && conda clean -afy
RUN conda install --yes --quiet --freeze-installed -c conda-forge \
    hdbscan \
    alpenglow \
    cufflinks-py \
    elasticsearch \
    geopandas \
    geopy \
    wfdb \
    folium \
    && conda clean -afy
RUN conda install --yes --quiet --freeze-installed \
    tensorflow keras \
    pymongo \
    && conda clean -afy

# cleanup:
RUN npm cache clean --force && \
    rm -rf $CONDA_DIR/share/jupyter/lab/staging && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

USER $NB_USER