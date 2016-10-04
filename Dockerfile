FROM oberthur/docker-ubuntu-java:jdk8_8.91.14

MAINTAINER Dawid Malinowski <d.malinowski@oberthur.com>

ENV HOME=/opt/app
ENV ACTIVEMQ_VERSION 5.14.1
WORKDIR /opt/app

ADD start-activemq.sh /bin/start-activemq.sh
ADD configure-connectors.sh /bin/configure-connectors.sh
ADD configure-authorization.sh /bin/configure-authorization.sh
ADD activemq.xml /opt/app/activemq.xml
ADD jetty.xml /opt/app/jetty.xml

# Install activemq
RUN chmod +x /bin/start-*.sh \
  && chmod +x /bin/configure-*.sh \
  && curl -LO https://www.apache.org/dist/activemq/${ACTIVEMQ_VERSION}/apache-activemq-${ACTIVEMQ_VERSION}-bin.tar.gz \
  && gunzip apache-activemq-${ACTIVEMQ_VERSION}-bin.tar.gz \
  && tar -xf apache-activemq-${ACTIVEMQ_VERSION}-bin.tar -C /opt/app \
  && mv apache-activemq-*/ apache-activemq/ \
  && chmod -x apache-activemq/bin/activemq \
  && mv activemq.xml apache-activemq/conf/activemq.xml \
  && mv jetty.xml apache-activemq/conf/jetty.xml \
  && rm apache-activemq-${ACTIVEMQ_VERSION}-bin.tar

# Add user app
RUN echo "app:x:999:999::/opt/app:/bin/false" >> /etc/passwd; \
  echo "app:x:999:" >> /etc/group; \
  mkdir -p /opt/app; chown app:app /opt/app

EXPOSE 61612 61613 61616 8161 8162

ENTRYPOINT ["/bin/start-activemq.sh"]
