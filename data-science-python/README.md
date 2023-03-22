# data-science-python docker image

Personalized docker image for Python-based data science, extending [Jupyter Docker Stacks](https://github.com/jupyter/docker-stacks) images (specifically the pyspark-notebook), adding
* Jupyterlab extensions for e.g. collapsible headings, TOC
* further command-line tools, e.g. ping and telnet,
* findspark for easy PySpark setup,
* BigQuery python client (google-cloud-bigquery),
* psycopg2 PostgreSQl python lib,
* elasticsearch
* alpenglow
* various other libraries, eg. twython, pymongo, scrapy, nltk, xmltodict, xgboost
* (removed: Turi Create, trectools, Jupyter notebook extensions for GIT, GitHub, LateX)

The goal is to enable testing and developing various alternative data processing pipelines on a single server or on a laptop, in a uniform Docker-based environment, before using the same or very 
similar notebooks in a production (possibly distributed) environment. 

Examples are available in the [GitHub repo](https://github.com/sidlo/docker-stacks), the compiled image in the [Docker Hub repo](https://hub.docker.com/r/sidlo/data-science-python).

## Running the image

We assume a Docker service running and Docker commands available. We map the user of the host OS to the user in the container, and a host OS folder as the home folder. This way we can work with our notebooks in a persistent home folder, with the user of our host OS. On Linux, run: 

    docker run --name data-science-python -d --user root --restart unless-stopped \
    -e "ES_ENABLED=true" -e "JUPYTERHUB_ENABLED=true" \
    -e "NB_USER=jovyan" -e "NB_GROUP=users" -e "NB_UID=[host uid]" -e "NB_GID=[host gid]" -e CHOWN_HOME_OPTS='-R' -w / \
    -p 8888:8888 --mount type=bind,src=/home/[host user]/jupyter-home,target=/home/jovyan \
    --memory="8000m" --memory-swap="8000m" --cpus="4" \
    -e "SPARK_OPTS=--driver-java-options=-Xmx8000M -XX:-UseGCOverheadLimit --driver-java-options=-Dlog4j.logLevel=info"
    sidlo/data-science-python

- if `ES_ENABLED` is set to "true", then ElasticSearch will be started when running the image
- if `JUPYTERHUB_ENABLED` is set to "true", then JupyterHub will be started when running the image
  - JupyterHub will be started with custom settings in `jupyterhub_custom_config.py`
- `NB_UID` and `NB_GID` are the UID and GID of the host OS which is used by Docker - the user should be able to read and write the mounted home directory,
- `NB_USER` and `NB_GROUP` are the user and group name inside the container - notebook service uses `/home/NB_USER` as home directory,
   - this home directory is mapped to the host source directory of `--mount`
   - `- e CHOWN_HOME=yes` might be required when users differ
- it is useful to set CPU and memory limits
   - we also have to set JVM parameters in `SPARK_OPTS` for Spark local to use the available container memory
   - also check if SparkSession options are set `spark.executor.memory` and `spark.driver.memory` (see the related example in [examples](https://github.com/sidlo/docker-stacks/examples))
- on Windows host, using [Docker Toolbox](https://docs.docker.com/toolbox/overview/): 
  - memory and CPU limits should be set in VirtualBox (Docker Toolbox is based on VirtualBox) - default is 1 CPU (use the VirtualBox GUI)

  - Use the GUI called “Kitematic”: open a CLI clicking the bottom-left “DOCKER CLI” icon
  - run the same `docker run` command as above, except that the mount should look something like 
  `type=bind,source=/c/Users/johndoe/jupyter-home,target=/home/johndoe`
- [Docker Desktop](https://www.docker.com/products/docker-desktop) on Windows 10 (professional) works also without issues

### Running the image with password, rather than an access token

By default, you have to fill in a Jupyter access token generated when starting the container to restrict access (see "Using the image" section to locate the token).

It is possible to use a custom password instead of the token. You can set the password's checksum as an argument when running the container:

    docker run ... sidlo/data-science-python custom-start.sh --NotebookApp.password="sha512:..."

Where the You can generate the checksum by running the following in e.g. an empty Jupyter notebook: (as of 2020.12, the default argon2 algorithm had ambiguous output, so we use sha512)

    from notebook.auth import passwd
    passwd(algorithm="sha512")

    Enter password: ········
    Verify password: ········
    'sha512:a792161c16ac:b3729c949700803d7fe5a90c371ae290f29cc79411a698345ad330acc262a97646ee5f674deea71cf6a52ec75c3c21f5943222dd1f6f6384d8c5ae87d8531d4a'

On older versions (older than 20210203) of the image, use start-notebook.sh instead of custom-start.sh:

    docker run ... sidlo/data-science-python start-notebook.sh --NotebookApp.password="sha512:..."

### Running the image without token or password

It is also possible to run the image without any authentication (e.g. for testing). Note that with all authentication disabled, anyone who can connect to the hosting machine will be able to run code! To do this, set the access token to empty when running the container:

    docker run ... sidlo/data-science-python custom-start.sh --NotebookApp.token=

On older versions (older than 20210203) of the image, use start-notebook.sh instead of custom-start.sh:

    docker run ... sidlo/data-science-python start-notebook.sh --NotebookApp.token=

### PySpark Arrow error workaround

On image versions newer than 20200702, when using PyArrow (spark.config("spark.sql.execution.arrow.enabled", "true")) it will fail unless a Spark config is set when creating SparkSession in PySpark.

Spark docs on this (https://spark.apache.org/docs/latest/):
“For Java 11, -Dio.netty.tryReflectionSetAccessible=true is required additionally for Apache Arrow library. This prevents java.lang.UnsupportedOperationException: sun.misc.Unsafe or java.nio.DirectByteBuffer.(long, int) not available when Apache Arrow uses Netty internally. ”

- One workaround is to set the config in every PySpark code/notebook
```
    SparkSession.builder.appName('...').config("spark.driver.extraJavaOptions", "-Dio.netty.tryReflectionSetAccessible=true")
```
  The notebook kernel has to be restarted for the config to take effect!
  Use spark.sparkContext.getConf().getAll() to check.

- Another way is to add it to Spark’s default config file:
```
    docker exec -it data-science-python-ecg /bin/bash
    cp /usr/local/spark/conf/spark-defaults.conf.template /usr/local/spark/conf/spark-defaults.conf
    nano /usr/local/spark/conf/spark-defaults.conf
```
  Config to be added:
```
    spark.driver.extraJavaOptions    -XX:-UseGCOverheadLimit -Dlog4j.logLevel=info -Dio.netty.tryReflectionSetAccessible=true
```

## Using the image
- the notebook service runs on port 8888: 
  - http://localhost:8888/ works for old Jupyter inteface,
  - http://localhost:8888/lab can be used for Jupyter Lab. 
  - Jupyter access token for authentication is written in the logs, to check run: 
  
    `docker logs --tail 3 data-science-python`

- the [examples](https://github.com/sidlo/docker-stacks/examples) folder contains simple notebook examples to get started: 
  - `*-f1.ipynb` notebook use a public formula-1 results dataset to demonstrate CSV input, aggragation and joins.
  - `turi*`, `spark*` and `pandas*` notebooks solve the same tasks using Turi Create SFrame, PySpark SQL and Pandas DataFrame.

## links
- the base image used is the [Docker Stacks pyspark-notebook](https://github.com/jupyter/docker-stacks/tree/master/pyspark-notebook)

