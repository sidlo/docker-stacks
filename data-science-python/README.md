# data-science-python docker image

Personalized docker image for Python-based data science, extending [Jupyter Docker Stacks](https://github.com/jupyter/docker-stacks) images (specifically the pyspark-notebook), adding
* Jupyterlab extensions for e.g. GIT, GitHub, Latex, TOC 
* further command-line tools, e.g. ping and telnet,
* findspark for easy PySpark setup,
* BigQuery python client,
* psycog2 PostgreSQl python lib,
* Turi Create

## running the image
We assume a Docker service running and Docker commands available. We map the user of the host OS to the user in the container, and a host OS folder as the home folder. This way we can work with our notebooks in a persistent home folder, with the user of our host OS. On Linux, run: 

    docker run --name data-science-python -d --user root -e "NB_USER=johndoe" -e "NB_UID=1000" -p 8888:8888 \
    --mount type=bind,source=/home/johndoe/jupyter-home,target=/home/johndoe \
    --memory="8000m"  --memory-swap="8000m" --cpus="4" sidlo/data-science-python

- `NB_UID` is the UID of the host OS which is used by Docker - the user should be able to read and write the mounted home directory,
- `NB_USER` is the user name of the container - notebooks then assume `/home/NB_USER` as the home directory
- this home directory is mapped to the host source directory of `--mount`
   - `- e CHOWN_HOME=yes` might be required when users differ
- it is useful to set CPU and memory limits
- on Windows host, using [Docker Toolbox](https://docs.docker.com/toolbox/overview/): 
  - memory and CPU limits should be set in VirtualBox (Docker Toolbox is based on VirtualBox) - default is 1 CPU (use the VirtualBox GUI)

  - Use the GUI called “Kitematic”: open a CLI clicking the bottom-left “DOCKER CLI” icon
  - run the same `docker run` command as above, except that the mount should look something like 
  `type=bind,source=/c/Users/johndoe/jupyter-home,target=/home/johndoe`
- [Docker Desktop](https://www.docker.com/products/docker-desktop) on Windows 10 (professional) should also work without issues, but was not tested yet

    
## using the image
- the notebook service runs on port 8888: 
  - http://localhost:8888/ works for old Jupyter inteface,
  - http://localhost:8888/lab can be used for Jupyter Lab. 
  - Jupyter access token for authentication is written in the logs, to check run: 
  
    `docker logs --tail 3 data-science-python`
- the [examples](../examples) folder contains simple notebook examples to get started: 
  - `*-f1.ipynb` notebook use a public formula-1 results dataset to demonstrate CSV input, aggragation and joins.
  - `turi*`, `spark*` and `pandas*` notebooks solve the same tasks using Turi Create SFrame, PySpark SQL and Pandas DataFrame.

## links
