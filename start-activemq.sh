#!/bin/bash
set -e
set -x

STORE_USAGE=${STORE_USAGE:=10}
TEMP_USAGE=${TEMP_USAGE:=5}
ADMIN_PASSWORD=${ADMIN_PASSWORD:=admin123}

ROOT_LOGGER_LEVEL=${ROOT_LOGGER_LEVEL:="INFO, console, logfile"}
ACTIVEMQ_SPRING_LOGGER_LEVEL=${ACTIVEMQ_SPRING_LOGGER_LEVEL:="WARN"}
ACTIVEMQ_WEB_HANDLER_LOGGER_LEVEL=${ACTIVEMQ_WEB_HANDLER_LOGGER_LEVEL:="WARN"}
SPRINGFRAMEWORK_LOGGER_LEVEL=${SPRINGFRAMEWORK_LOGGER_LEVEL:="WARN"}
CAMEL_LOGGER_LEVEL=${CAMEL_LOGGER_LEVEL:="INFO"}
CONSOLE_APPENDER_THRESHOLD_LEVEL=${CONSOLE_APPENDER_THRESHOLD_LEVEL:="INFO"}

sed -i -e "s/<storeUsage limit=\"100 gb\"\/>/<storeUsage limit=\"${STORE_USAGE} gb\"\/>/" /opt/app/apache-activemq/conf/activemq.xml
sed -i -e "s/<tempUsage limit=\"50 gb\"\/>/<tempUsage limit=\"5 gb\"\/>/" /opt/app/apache-activemq/conf/activemq.xml

# Setting up rootLogger level
sed -i -e "s/log4j.rootLogger=INFO, console, logfile/log4j.rootLogger=${ROOT_LOGGER_LEVEL}/g" /opt/app/apache-activemq/conf/log4j.properties

# Setting up activemq logger level
sed -i -e "s/log4j.logger.org.apache.activemq.spring=WARN/log4j.logger.org.apache.activemq=${ACTIVEMQ_SPRING_LOGGER_LEVEL}/g" /opt/app/apache-activemq/conf/log4j.properties

# Setting up activemq web handler logger level
sed -i -e "s/log4j.logger.org.apache.activemq.web.handler=WARN/log4j.logger.org.apache.activemq.web.handler=${ACTIVEMQ_WEB_HANDLER_LOGGER_LEVEL}/g" /opt/app/apache-activemq/conf/log4j.properties

# Setting up springframework logger level
sed -i -e "s/log4j.logger.org.springframework=WARN/log4j.logger.org.springframework=${SPRINGFRAMEWORK_LOGGER_LEVEL}/g" /opt/app/apache-activemq/conf/log4j.properties

# Setting up camel logger level
sed -i -e "s/log4j.logger.org.apache.camel=INFO/log4j.logger.org.apache.camel=${CAMEL_LOGGER_LEVEL}/g" /opt/app/apache-activemq/conf/log4j.properties

# Setting up console appender threshold
sed -i -e "s/log4j.appender.console.threshold=INFO/log4j.appender.console.threshold=${CONSOLE_APPENDER_THRESHOLD_LEVEL}/g" /opt/app/apache-activemq/conf/log4j.properties

# Enabling Network Of Brokers
if [[ -v NETWORK_OF_BROKERS_CONNECTORS_URI ]]; then
  sed -i -e "s/<\/shutdownHooks>/<\/shutdownHooks>\\n<networkConnectors>\\n<networkConnector uri=\"${NETWORK_OF_BROKERS_CONNECTORS_URI}\"\/>\\n<\/networkConnectors>/g" /opt/app/apache-activemq/conf/activemq.xml
fi

sed -i -e "s/admin activemq/admin ${ADMIN_PASSWORD}/" /opt/app/apache-activemq/conf/jmx.password
sed -i -e "s/admin: admin, admin/admin: ${ADMIN_PASSWORD}, admin/" /opt/app/apache-activemq/conf/jetty-realm.properties
sed -i -e 's/user: user, user//' /opt/app/apache-activemq/conf/jetty-realm.properties

/bin/start-connectors.sh
if [ $? -ne 0 ]; then
    exit 1
fi
/bin/start-authorization.sh
if [ $? -ne 0 ]; then
    exit 1
fi

JVM_OPTS="-server -verbose:gc -XX:+UseCompressedOops -Xms512m -Xmx512m -XX:MetaspaceSize=64M -XX:MaxMetaspaceSize=64M"

exec java ${JVM_OPTS} -Djava.util.logging.config.file=logging.properties -jar /opt/app/apache-activemq/bin/activemq.jar start

