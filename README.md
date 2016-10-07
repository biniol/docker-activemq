# Docker image containing ActiveMQ
Basic Docker image to run activemq as user app (999:999)


*General*

- **STORE_USAGE**: value in GB (default value is `10`)
- **TEMP_USAGE**: value in GB (default value is `5`)
- **ADMIN_PASSWORD**: provide admin password (default `admin123`)
- **PERSISTANCE_ENABLED**: enables broker persistance. It's off by default. If you want make it on set PERSISTANCE_ENABLED=true


*Network connectors*

- **ACTIVE_MQ_TRANSPORT_CONNECTOR_NAMES**: available values **OPENWIRE,AMQP,MQTT,STOMP,STOMPSSL,WS,SSL**. This parametr is **OBLIGATORY**. Connector names should be separated by comma.
- **ACTIVE_MQ_TRANSPORT_CONNECTOR_WS_PORT**: port for WS connector (default value 61614)
- **ACTIVE_MQ_TRANSPORT_CONNECTOR_OPENWIRE_PORT**: port for OPENWIRE connector (default value 61616)
- **ACTIVE_MQ_TRANSPORT_CONNECTOR_SSL_KEYSTOREPASSWORD**: password for keystore file
- **ACTIVE_MQ_TRANSPORT_CONNECTOR_SSL_TRUSTSTOREPASSWORD**: pasword for truststore file
- **ACTIVE_MQ_TRANSPORT_CONNECTOR_SSL_PORT**: port for SSL connector (default value 61617)
- **ACTIVE_MQ_TRANSPORT_CONNECTOR_MQTT_PORT**: port for MQTT connector (default value 1883)
- **ACTIVE_MQ_TRANSPORT_CONNECTOR_AMQP_PORT**: port for AMQP connector (default value 5672)
- **ACTIVE_MQ_TRANSPORT_CONNECTOR_STOMP_PORT**: port for STOMP connector (default value 61613)
- **ACTIVE_MQ_TRANSPORT_CONNECTOR_STOPMSSL_PORT** port for STOMPSSL connector (default value 61612)
- **NETWORK_OF_BROKERS_CONNECTORS_URI**: possibility to configure network of brokers. As this env variable is part of `sed` command it needs to escape all special characters like in `sed` f.e.:


*Authorization*

- **ACTIVE_MQ_AUTHORIZATION_QUEUE_NAMES** names of queues with authorization
- **ACTIVE_MQ_AUTHORIZATION_QUEUE_${QUEUE_NAME}_READ** role with read authorization for topic
- **ACTIVE_MQ_AUTHORIZATION_QUEUE_${QUEUE_NAME}_WRITE** role with write authorization for topic
- **ACTIVE_MQ_AUTHORIZATION_QUEUE_${QUEUE_NAME}_ADMIN** role with admin authorization for topic
- **ACTIVE_MQ_AUTHORIZATION_TOPIC_NAMES** names of topics with authorization
- **ACTIVE_MQ_AUTHORIZATION_QUEUE_${TOPIC_NAME}_READ** role with read authorization for topic
- **ACTIVE_MQ_AUTHORIZATION_QUEUE_${TOPIC_NAME}_WRITE** role with write authorization for topic
- **ACTIVE_MQ_AUTHORIZATION_QUEUE_${TOPIC_NAME}_ADMIN** role with admin authorization for topic
- **ACTIVE_MQ_AUTHORIZATION_TEMP_QUEUES_READ** role with read authorization for temporary queue
- **ACTIVE_MQ_AUTHORIZATION_TEMP_QUEUES_WRITE** role with write authorization for temporary queue
- **ACTIVE_MQ_AUTHORIZATION_TEMP_QUEUES_ADMIN** role with admin authorization for temporary queue
- **ACTIVE_MQ_AUTHORIZATION_TOPIC_ADVISORY_READ** role with read authorization for advisory topics
- **ACTIVE_MQ_AUTHORIZATION_TOPIC_ADVISORY_WRITE** role with write authorization for advisory topics
- **ACTIVE_MQ_AUTHORIZATION_TOPIC_ADVISORY_ADMIN** role with admin authorization for advisory topics


*Logging:*

- **ROOT_LOGGER_LEVEL** - changes `log4j.rootLogger` (default value: `INFO, console, logfile`)
- **ACTIVEMQ_SPRING_LOGGER_LEVEL** - changes `log4j.logger.org.apache.activemq.spring` (default value: `WARN`)
- **ACTIVEMQ_WEB_HANDLER_LOGGER_LEVEL** - changes `log4j.logger.org.apache.activemq.web.handler` (default value: `WARN`)
- **SPRINGFRAMEWORK_LOGGER_LEVEL** - changes `log4j.logger.org.springframework` (default value: `WARN`)
- **CAMEL_LOGGER_LEVEL** - changes `log4j.logger.org.apache.camel` (default value: `INFO`)
- **CONSOLE_APPENDER_THRESHOLD_LEVEL** - changes `log4j.appender.console.threshold` (default value: `INFO`)


*Mounts*

- **/opt/app/broker.ks** - broker keystore for SSL connection
- **/opt/app/broker.ts** - broker truststore for SSL connection
- **/opt/app/apache-activemq/conf/login.config** - login policy config
- **/opt/app/apache-activemq/conf/users.properties** - users configuration
- **/opt/app/apache-activemq/conf/groups.properties** - groups configuration


*Examples*

Examples are included in **examples** dir.
**minimal-tcp-config** - example of minimal activemq tcp connector config
**minimal-ssl-config** - example of using ssl connection of activemq
**network-of-brokers-with-ssl-config** - example of activemq config with **network of brokers** architecture and producer/consumer ssl connection.
