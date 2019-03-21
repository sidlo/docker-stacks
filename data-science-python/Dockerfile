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

# pypi packages:  
RUN pip install findspark
#RUN pip install 'ggplot==0.6.8'
RUN pip install turicreate

# uninstall packages to get the newest ones: 
# RUN jupyter labextension uninstall @jupyterlab/hub-extension

# JupyterLab sparkmonitor extensions: 
RUN pip install sparkmonitor  && \
    jupyter nbextension install sparkmonitor --py --user --symlink  && \
    jupyter nbextension enable sparkmonitor --py --user  && \
    jupyter serverextension enable --py --user sparkmonitor && \
    ipython profile create && echo "c.InteractiveShellApp.extensions.append('sparkmonitor.kernelextension')" >>  $(ipython profile locate default)/ipython_kernel_config.py

# JupyterLab GIT extension: 
RUN jupyter labextension install @jupyterlab/git && \
    pip install jupyterlab-git && \
    jupyter serverextension enable --py --sys-prefix jupyterlab_git

# other python libraries and JupyterLab extensions: 
RUN pip install xgboost && \
    pip install ipywidgets && \
    pip install psycopg2-binary && \
    pip install --upgrade google-cloud-bigquery && \
    pip install -e git+https://github.com/SohierDane/BigQuery_Helper#egg=bq_helper && \
    $CONDA_DIR/bin/conda install --quiet --yes -c conda-forge ipywidgets && \
    jupyter labextension install @jupyterlab/fasta-extension && \
    jupyter labextension install @jupyterlab/geojson-extension && \
    jupyter labextension install @jupyterlab/github && \
    jupyter labextension install @jupyterlab/plotly-extension && \
    jupyter labextension install @jupyterlab/vega2-extension && \
    jupyter labextension install @jupyterlab/latex && \
    jupyter labextension install beakerx-jupyterlab && \
    jupyter labextension install @jupyterlab/toc && \
    jupyter labextension install bqplot && \
    jupyter labextension install @jupyterlab/google-drive && \
    jupyter labextension install jupyterlab-kernelspy && \
    jupyter labextension install qgrid && \
    jupyter labextension install knowledgelab

#   jupyter labextension install jupyterlab_voyager && \
#   jupyter labextension install @jpmorganchase/perspective-jupyterlab && \

# various further data science libraries
RUN pip install twython && \
    pip install pymongo && \
    pip install scrapy && \
    pip install elasticsearch && \
    pip install nltk && \
    pip install trectools && \
    pip install xmltodict && \
    conda install -c conda-forge alpenglow
    #pip install trec_eval && \

# cleanup: 
RUN npm cache clean --force && \
    rm -rf $CONDA_DIR/share/jupyter/lab/staging && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

#   jupyter notebook --generate-config && \
