# Apache Mirror Maker 2

Kafka MirrorMaker2 replicates data between Kafka clusters. This process is called mirroring to avoid
confusion with the Kafka partitions replication concept. MirrorMaker2 consumes messages from the
source cluster and republishes those messages to the target cluster.

From cluster source, it is needed to extract the Cluster CA Cert and the user credentials needed
to connect:

```shell
oc get secret event-bus-cluster-ca-cert -o yaml > source-secrets/event-bus-source-cluster-ca-cert.yaml
```

As there is already a certificate in target cluster with the same name (because both cluster have the
same name), we need to create the new secret with a different name. Remove the data not needed and
clean the secret to be created in the target cluster.

```shell
oc get secret migration-user-tls -o yaml > source-secrets/migration-user-tls.yaml
```

Remove the data not needed and clean the secret to be created in the target cluster, and rename the
source secret name to `event-bus-source-cluster-ca-cert`:

```shell
oc apply -f ./source-secrets/
```

Finally we deploy the MirrorMaker2 as: change bootstrapServers: of source cluster before run

```shell
oc apply -f mm2-metric-cm.yml
oc apply -f event-bus-mirror-maker2-noauth.yml
```

To confirm the status of the MirrorMaker2:

```shell
❯ oc get kafkamirrormaker2
NAME                     DESIRED REPLICAS   READY
event-bus-mm2-migrator   1                  True
```

Define a active (source) to passive (target) cluster.

This MirrorMaker will mirror messages coming from `apps.sample.greetings` and `apps.sample.greetings` topics
from the source to the target Kafka Cluster. In general any topic and data created in the source Kafka cluster
will be migrated into the target Kafka cluster.


oc get secret admin-user-scram -o jsonpath='{.data.password}' | base64 -d


oc run kafka-info1 -ti --image=quay.io/strimzi/kafka:latest-kafka-3.2.0 --rm=true --restart=Never -- /bin/bash -c "cat >/tmp/kafka.properties <<EOF 
security.protocol=SASL_PLAINTEXT
sasl.mechanism=SCRAM-SHA-512
sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required username=admin-user-scram password=oz72h8GO7Y93;
EOF
bin/kafka-topics.sh --bootstrap-server event-bus-kafka-bootstrap:9092 --topic my-topic --describe --command-config=/tmp/kafka.properties
"

oc run kafka-info1 -ti --image=quay.io/strimzi/kafka:latest-kafka-3.2.0 --rm=true --restart=Never -- /bin/bash -c "bin/kafka-topics.sh --bootstrap-server event-bus-kafka-bootstrap:9092 --topic my-topic --describe
"

latest -1
earliest -2
oc run kafka-info2 -ti --image=quay.io/strimzi/kafka:latest-kafka-3.2.0 --rm=true --restart=Never -- /bin/bash -c "cat >/tmp/kafka.properties <<EOF 
security.protocol=SASL_PLAINTEXT
sasl.mechanism=SCRAM-SHA-512
sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required username=admin-user-scram password=oz72h8GO7Y93;
EOF
bin/kafka-get-offsets.sh --bootstrap-server event-bus-kafka-bootstrap:9092 --topic my-topic --time -2 --command-config=/tmp/kafka.properties
"

oc run kafka-info2 -ti --image=quay.io/strimzi/kafka:latest-kafka-3.2.0 --rm=true --restart=Never -- /bin/bash -c "bin/kafka-get-offsets.sh --bootstrap-server event-bus-kafka-bootstrap:9092 --topic my-topic --time -2
"

oc run kafka-info2 -ti --image=quay.io/strimzi/kafka:latest-kafka-3.2.0 --rm=true --restart=Never -- /bin/bash -c "cat >/tmp/kafka.properties <<EOF 
security.protocol=SASL_PLAINTEXT
sasl.mechanism=SCRAM-SHA-512
sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required username=admin-user-scram password=oz72h8GO7Y93;
EOF
bin/kafka-get-offsets.sh --bootstrap-server event-bus-kafka-bootstrap:9092 --topic my-topic --time -1 --command-config=/tmp/kafka.properties
"

oc run kafka-info2 -ti --image=quay.io/strimzi/kafka:latest-kafka-3.2.0 --rm=true --restart=Never -- /bin/bash -c "bin/kafka-get-offsets.sh --bootstrap-server event-bus-kafka-bootstrap:9092 --topic my-topic --time -1
"


oc run kafka-info3 -ti --image=quay.io/strimzi/kafka:latest-kafka-3.2.0 --rm=true --restart=Never -- /bin/bash -c "cat >/tmp/kafka.properties <<EOF 
security.protocol=SASL_PLAINTEXT
sasl.mechanism=SCRAM-SHA-512
sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required username=admin-user-scram password=oz72h8GO7Y93;
EOF
bin/kafka-consumer-groups.sh --bootstrap-server event-bus-kafka-bootstrap:9092 --describe --all-groups --command-config=/tmp/kafka.properties
"

oc run kafka-info3 -ti --image=quay.io/strimzi/kafka:latest-kafka-3.2.0 --rm=true --restart=Never -- /bin/bash -c "bin/kafka-consumer-groups.sh --bootstrap-server event-bus-kafka-bootstrap:9092 --describe --all-groups
"

oc run kafka-info3 -ti --image=quay.io/strimzi/kafka:latest-kafka-3.2.0 --rm=true --restart=Never -- /bin/bash -c "cat >/tmp/kafka.properties <<EOF 
security.protocol=SASL_PLAINTEXT
sasl.mechanism=SCRAM-SHA-512
sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required username=admin-user-scram password=oz72h8GO7Y93;
EOF
bin/kafka-consumer-groups.sh --bootstrap-server event-bus-kafka-bootstrap:9092 --describe --group test-group --command-config=/tmp/kafka.properties
"

oc run kafka-info3 -ti --image=quay.io/strimzi/kafka:latest-kafka-3.2.0 --rm=true --restart=Never -- /bin/bash -c "bin/kafka-consumer-groups.sh --bootstrap-server event-bus-kafka-bootstrap:9092 --describe --group test-group
"


oc apply -f 06-deployment-consumer.yml
oc delete -f 06-deployment-consumer.yml

add mirror maker 2 dashboard in grafana

* [Kafka MirrorMaker 2.0 Configuration](https://strimzi.io/docs/operators/latest/using.html#assembly-mirrormaker-str)
