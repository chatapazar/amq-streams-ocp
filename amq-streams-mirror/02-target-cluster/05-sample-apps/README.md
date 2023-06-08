# Verifying MirrorMaker2 

To verify that messages are stored in the target Apache Kafka cluster, we will deploy
a set of applications to check that we have data coming from the source cluster:

```shell
oc apply -f check-apps/
```

These applications are deployed as:

```shell
❯ oc get deployment
NAME                                            READY   UP-TO-DATE   AVAILABLE   AGE
hello-world-consumer-check-greetings            1/1     1            1           61m
hello-world-consumer-check-greetings-reversed   1/1     1            1           61m
```

Checking the logs of the pods created we could confirm that we are consuming data in the target cluster
with data produced in the source cluster.

# Migration Consumers

Now we could stop de original consumer from source cluster and start a new one in the target. As the consumers offset
are sync, the new instances only process the latest records not processed in the source cluster.

Execute in the source cluster:

```shell
oc scale --replicas=0 deployment/hello-world-streams
oc scale --replicas=0 deployment/hello-world-consumer
```

Deploy in the target cluster:

```shell
oc apply -f ./consumer-apps/
```

Now you could check that the new consumers in the target cluster are consuming the data starting from the latest
offset processed in the source cluster.

Now, the last step is move your producer apps to this new Kafka cluster.


# Test Offset

- create new topic in source cluster
  
```shell
oc apply -f test/itmx-topic.yml
```

grant user to new topic,  update sample-user-scram
```shell
oc apply -f test/sample-user-scram.yml
```

- check topic create in both source & target cluster

* Sample consumer authenticated with the ```sample-user-scram``` user:

```shell
oc run kafka-consumer -ti --image=quay.io/strimzi/kafka:latest-kafka-3.2.0 --rm=true --restart=Never -- /bin/bash -c "cat >/tmp/consumer.properties <<EOF 
security.protocol=SASL_PLAINTEXT
sasl.mechanism=SCRAM-SHA-512
sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required username=sample-user-scram password=fcDlcdSFPovO;
EOF
bin/kafka-console-consumer.sh --bootstrap-server event-bus-kafka-bootstrap:9092 --topic app.itmx --consumer.config=/tmp/consumer.properties --group sample-group
"
```

* Sample producer authenticated with the ```sample-user-scram``` user:

```shell
oc run kafka-producer -ti --image=quay.io/strimzi/kafka:latest-kafka-3.2.0 --rm=true --restart=Never -- /bin/bash -c "cat >/tmp/producer.properties <<EOF 
security.protocol=SASL_PLAINTEXT
sasl.mechanism=SCRAM-SHA-512
sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required username=sample-user-scram password=fcDlcdSFPovO;
EOF
bin/kafka-console-producer.sh --broker-list event-bus-kafka-bootstrap:9092 --topic app.itmx --producer.config=/tmp/producer.properties
"
```

send a,b,c
wait until consumer get a,b,c
stop consumer
send d,e,f
grant user to new topic,  update sample-user-scram
run consumer in target cluster, check password before run
oc get secret sample-user-scram -o jsonpath='{.data.password}' | base64 -d
```shell
oc run kafka-consumer -ti --image=quay.io/strimzi/kafka:latest-kafka-3.2.0 --rm=true --restart=Never -- /bin/bash -c "cat >/tmp/consumer.properties <<EOF 
security.protocol=SASL_PLAINTEXT
sasl.mechanism=SCRAM-SHA-512
sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required username=sample-user-scram password=zsLsfc0t9KVQ;
EOF
bin/kafka-console-consumer.sh --bootstrap-server event-bus-kafka-bootstrap:9092 --topic itmx --consumer.config=/tmp/consumer.properties --group sample-group
"
```

oc run kafka-consumer -ti --image=quay.io/strimzi/kafka:latest-kafka-3.2.0 --rm=true --restart=Never -- /bin/bash -c "cat >/tmp/consumer.properties <<EOF 
security.protocol=SASL_PLAINTEXT
sasl.mechanism=SCRAM-SHA-512
sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required username=sample-user-scram password=zsLsfc0t9KVQ;
EOF
bin/kafka-console-consumer.sh --bootstrap-server event-bus-kafka-bootstrap:9092 --topic itmx --consumer.config=/tmp/consumer.properties
"


oc run kafka-consumer -ti --image=quay.io/strimzi/kafka:latest-kafka-3.2.0 --rm=true --restart=Never -- /bin/bash -c "cat >/tmp/consumer.properties <<EOF
security.protocol=SASL_PLAINTEXT
sasl.mechanism=SCRAM-SHA-512
sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required username=admin-user-scram password=adKQsEuXKVEV;
EOF
bin/kafka-consumer-groups.sh --bootstrap-server event-bus-kafka-bootstrap:9092 --describe --all-groups --command-config /tmp/consumer.properties
"

oc run kafka-consumer -ti --image=quay.io/strimzi/kafka:latest-kafka-3.2.0 --rm=true --restart=Never -- /bin/bash -c "cat >/tmp/consumer.properties <<EOF
security.protocol=SASL_PLAINTEXT
sasl.mechanism=SCRAM-SHA-512
sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required username=admin-user-scram password=CZgD6tJVvDuq;
EOF
bin/kafka-consumer-groups.sh --bootstrap-server event-bus-kafka-bootstrap:9092 --describe --all-groups --command-config /tmp/consumer.properties
"

oc run kafka-consumer -ti --image=quay.io/strimzi/kafka:latest-kafka-3.2.0 --rm=true --restart=Never -- /bin/bash -c "bin/kafka-consumer-groups.sh --bootstrap-server event-bus-kafka-bootstrap:9092 --describe --all-groups
"