FROM derek163/presto:0.213
MAINTAINER derek "derek@test.com"

ENV PRESTO_DIR /opt/presto
ENV PRESTO_ETC_DIR /opt/presto/etc
ENV PRESTO_DATA_DIR /data

WORKDIR ${PRESTO_DIR}
RUN pwd

# config node.properties
RUN echo "node.environment=ci\n\
node.id=faaaafffffff-ffff-ffff-ffff-ffffffffffff\n\
node.data-dir=${PRESTO_DATA_DIR}\n"\ > ${PRESTO_ETC_DIR}/node.properties

RUN echo '-server\n\
-Xmx1G\n\
-XX:+UseG1GC\n\
-XX:G1HeapRegionSize=32M\n\
-XX:+UseGCOverheadLimit\n\
-XX:+ExplicitGCInvokesConcurrent\n\
-XX:+HeapDumpOnOutOfMemoryError\n\
-XX:+ExitOnOutOfMemoryError\n'\ > ${PRESTO_ETC_DIR}/jvm.config

RUN echo 'coordinator=true\n\
node-scheduler.include-coordinator=true\n\
http-server.http.port=8888\n\
query.max-memory=0.4GB\n\
query.max-memory-per-node=0.2GB\n\
discovery-server.enabled=true\n\
discovery.uri=http://127.0.0.1:8888\n'\ > ${PRESTO_ETC_DIR}/config.properties

RUN echo 'com.facebook.presto=WARN\n'\ > ${PRESTO_ETC_DIR}/log.properties

RUN echo 'connector.name=mysql\n\
connection-url=jdbc:mysql://127.0.0.1:3306\n\
connection-user=root\n\
connection-password=123456\n'\ > ${PRESTO_ETC_DIR}/catalog/mysql.properties


COPY ./presto_docker_entrypoint.sh /presto_docker_entrypoint.sh
ENTRYPOINT ["bash", "/presto_docker_entrypoint.sh"]
