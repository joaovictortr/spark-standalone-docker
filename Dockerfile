FROM openjdk:16-jdk-buster

ARG SPARK_VERSION="3.0.0"
ARG HADOOP_VERSION="2.7"

ENV SPARK_NO_DAEMONIZE="true"
ENV SPARK_MASTER_HOST="spark-master"
ENV SPARK_LOCAL_DIRS="/data"
ENV SPARK_HOME "/opt/spark"

RUN apt-get update \
    && apt-get install --yes gnupg2 python3 python3-pip \
    && apt-get clean \
    && pip3 install --no-cache --upgrade pip

# Get Spark
RUN curl --progress --output "/opt/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz" \
       "https://downloads.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz" \
    # Verify checksum for the Spark installation
    && curl --progress --output "/opt/KEYS" "https://downloads.apache.org/spark/KEYS" \
    && gpg --import "/opt/KEYS" \
    && curl --progress --output "/opt/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz.asc" \
        "https://downloads.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz.asc" \
    && gpg --verify "/opt/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz.asc" \
                    "/opt/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz" \
    && rm "/opt/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz.asc" \
    && cd /opt \
    && tar -xf "/opt/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz" \
    && rm -rf "/opt/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz" \
    && mv "/opt/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}" "/opt/spark"

RUN mkdir /data
VOLUME "/data"

EXPOSE 8080/tcp 8081/tcp 7077/tcp 6066/tcp

ADD scripts/spark-init.sh /spark-init.sh

WORKDIR /opt/spark
ENTRYPOINT ["/spark-init.sh"]
