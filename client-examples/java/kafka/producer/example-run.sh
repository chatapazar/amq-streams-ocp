#!/bin/sh
export STRIMZI_TOPIC=my-topic
export STRIMZI_DELAY_MS=1000
export STRIMZI_LOG_LEVEL=INFO
export STRIMZI_MESSAGE_COUNT=1000000
export KAFKA_BOOTSTRAP_SERVERS=my-cluster-kafka-bootstrap-amq-streams-test.apps.cluster-2j5j5.2j5j5.sandbox1138.opentlc.com:443
export KAFKA_KEY_SERIALIZER=org.apache.kafka.common.serialization.StringSerializer
export KAFKA_VALUE_SERIALIZER=org.apache.kafka.common.serialization.StringSerializer
export KAFKA_SECURITY_PROTOCOL=SSL
export KAFKA_SSL_TRUSTSTORE_CERTIFICATES=$(cat ca.crt)
export KAFKA_SSL_TRUSTSTORE_TYPE=PEM
export KAFKA_SSL_KEYSTORE_CERTIFICATE_CHAIN=$(cat user.crt)
export KAFKA_SSL_KEYSTORE_KEY=$(cat user.key)
export KAFKA_SSL_KEYSTORE_TYPE=PEM

#echo $KAFKA_SSL_KEYSTORE_KEY
java -D -jar target/java-kafka-producer-1.0-SNAPSHOT.jar  