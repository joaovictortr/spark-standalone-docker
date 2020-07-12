#!/bin/bash

. "${SPARK_HOME}/sbin/spark-config.sh"
. "${SPARK_HOME}/bin/load-spark-env.sh"

if [[ "master" == "$1" ]]; then
    "${SPARK_HOME}/bin/spark-class" org.apache.spark.deploy.master.Master
elif [[ "worker" == "$1" ]]; then
    "${SPARK_HOME}/bin/spark-class" org.apache.spark.deploy.worker.Worker "$2"
elif [[ "shell" == "$1" ]]; then
    "${SPARK_HOME}/bin/spark-shell" --master "$2"
fi
