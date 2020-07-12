# Spark Standalone Cluster using Docker 

Docker image with Spark in Standalone Cluster mode.

The docker-compose file assumes you have the `spark-cluster` network in place.

Make sure you have the `spark-cluster` network created for the docker-compose file to work properly:

```
docker network create spark-cluster
```

After creating the network, you can spin up the cluster by running the following command:

```
# Spins up the cluster with 5 workers
docker-compose up --scale spark-worker=5 spark-master spark-worker
```

There is also the possibility of using the spark shell:

```
# Setup a Spark shell session, which is connected to the cluster
docker-compose run --rm spark-shell
```
