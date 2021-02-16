c.JupyterHub.bind_url ='http://0.0.0.0:8000/jupyterhub'
c.Spawner.environment = {
  'SPARK_HOME': '/usr/local/spark',
  'HADOOP_VERSION': '3.2',
  'SHELL': '/bin/bash',
  'SPARK_OPTS': '--driver-java-options=-Xmx8000M -XX:-UseGCOverheadLimit --driver-java-options=-Dlog4j.logLevel=info',
  'APACHE_SPARK_VERSION': '3.0.1'
}