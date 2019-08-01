# Start from a core stack version
FROM jupyter/pyspark-notebook:latest

# additinal ubuntu packages:
USER root
RUN sudo apt-get update && apt-get install -y telnet iputils-ping 
RUN sudo apt-get install -y libblas3 liblapack3 libstdc++6 python-setuptools graphviz

# additional python packages (with the default user of pyspark-notebook):
USER $NB_UID 

# update pip (required for eg. turicreate)
RUN pip install -U pip

# uninstall packages to get the newest ones: 
# RUN jupyter labextension uninstall @jupyterlab/hub-extension

# JupyterLab extensions: 
RUN pip install sparkmonitor  && \
    jupyter nbextension install sparkmonitor --py --user --symlink  && \
    jupyter nbextension enable sparkmonitor --py --user  && \
    jupyter serverextension enable --py --user sparkmonitor && \
    ipython profile create && echo "c.InteractiveShellApp.extensions.append('sparkmonitor.kernelextension')" >>  $(ipython profile locate default)/ipython_kernel_config.py

RUN $CONDA_DIR/bin/conda install --quiet --yes -c conda-forge ipywidgets && \
    jupyter labextension install @jupyterlab/git && \
    pip install jupyterlab-git && \
    jupyter serverextension enable --py --sys-prefix jupyterlab_git && \
#    jupyter labextension install @jupyterlab/fasta-extension && \
    pip install jupyterlab_latex && \
    jupyter serverextension enable --sys-prefix jupyterlab_latex && \
    jupyter labextension install @jupyterlab/latex && \
    jupyter labextension install @jupyterlab/geojson-extension && \
    jupyter labextension install @jupyterlab/github && \
    jupyter labextension install @jupyterlab/plotly-extension && \
    jupyter labextension install @jupyterlab/vega2-extension && \
    jupyter labextension install beakerx-jupyterlab && \
    jupyter labextension install @jupyterlab/toc && \
#    jupyter labextension install @jupyterlab/google-drive && \
    jupyter labextension install jupyterlab-kernelspy && \
    jupyter labextension install qgrid && \
#    jupyter labextension install knowledgelab && \
    jupyter labextension install jupyterlab-drawio && \
    jupyter labextension install @krassowski/jupyterlab_go_to_definition && \
    jupyter labextension install @mflevine/jupyterlab_html && \
    jupyter labextension install jupyterlab_bokeh && \
    jupyter labextension install bqplot

# other python libraries
RUN pip install psycopg2-binary && \
    pip install --upgrade google-cloud-bigquery && \
    pip install -e git+https://github.com/SohierDane/BigQuery_Helper#egg=bq_helper

RUN pip install findspark
# have to wait for turicreate python 3.7 support: 
#RUN pip install turicreate

#RUN pip install 'ggplot==0.6.8'

RUN pip install twython && \
    pip install pymongo && \
    pip install scrapy && \
    pip install elasticsearch && \
    pip install nltk && \
    pip install xmltodict && \
    pip install folium && \
    pip install geopandas && \
    pip install geopy && \
    pip install graphviz

# further ML and deep learning packages: 
RUN pip install xgboost
RUN $CONDA_DIR/bin/conda install --yes --quiet -c conda-forge alpenglow
RUN $CONDA_DIR/bin/conda install --yes --quiet tensorflow keras

# cleanup: 
RUN npm cache clean --force && \
    rm -rf $CONDA_DIR/share/jupyter/lab/staging && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER
