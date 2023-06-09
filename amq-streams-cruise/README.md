oc login --insecure-skip-tls-verify
oc new-project amq-streams-cruise

-->create 3 broker
oc apply -f kafka-cruise-control.yaml

deploy obsidiandynamics/kafdrop
set KAFKA_BROKERCONNECT=my-cluster-kafka-bootstrap:9092
port 9000:9000


oc apply -f my-topic.yml

oc run kafka-info1 -ti --image=quay.io/strimzi/kafka:latest-kafka-3.2.0 --rm=true --restart=Never -- /bin/bash -c "bin/kafka-topics.sh --bootstrap-server my-cluster-kafka-bootstrap:9092 --topic my-topic --describe
"

oc run kafka-producer-perf -ti --image=quay.io/strimzi/kafka:latest-kafka-3.2.0 --rm=true --restart=Never -- /bin/bash -c "cat >/tmp/producer.properties <<EOF 
bootstrap.servers=my-cluster-kafka-bootstrap:9092
EOF
bin/kafka-producer-perf-test.sh --topic my-topic --num-records 1000000 --throughput -1 --record-size 2048 --print-metrics --producer.config=/tmp/producer.properties
"

oc run kafka-info1 -ti --image=quay.io/strimzi/kafka:latest-kafka-3.2.0 --rm=true --restart=Never -- /bin/bash -c "bin/kafka-topics.sh --bootstrap-server my-cluster-kafka-bootstrap:9092 --topic my-topic --describe
"

oc run kafka-info1 -ti --image=quay.io/strimzi/kafka:latest-kafka-3.2.0 --rm=true --restart=Never -- /bin/bash -c "bin/kafka-log-dirs.sh --describe --bootstrap-server my-cluster-kafka-bootstrap:9092 --topic-list my-topic
"

oc run kafka-info1 -ti --image=quay.io/strimzi/kafka:latest-kafka-3.2.0 --rm=true --restart=Never -- /bin/bash -c "bin/kafka-run-class.sh kafka.tools.GetOffsetShell --broker-list my-cluster-kafka-bootstrap:9092 --topic my-topic
"

oc run kafka-info1 -ti --image=edenhill/kcat:1.7.1 --rm=true --restart=Never -- -b my-cluster-kafka-bootstrap:9092 -L -t my-topic

edit broker to 4
oc apply -f kafka-cruise-control.yaml

wait until start 4 broker

oc run kafka-info1 -ti --image=quay.io/strimzi/kafka:latest-kafka-3.2.0 --rm=true --restart=Never -- /bin/bash -c "bin/kafka-log-dirs.sh --describe --bootstrap-server my-cluster-kafka-bootstrap:9092 --topic-list my-topic
"

oc run kafka-info1 -ti --image=quay.io/strimzi/kafka:latest-kafka-3.2.0 --rm=true --restart=Never -- /bin/bash -c "bin/kafka-topics.sh --bootstrap-server my-cluster-kafka-bootstrap:9092 --topic my-topic --describe
"

oc apply -f kafka-rebalance.yaml

oc describe kafkarebalance my-rebalance -n amq-streams-cruise     

oc annotate kafkarebalance my-rebalance strimzi.io/rebalance=approve -n amq-streams-cruise

wait until change to rebalancing

oc describe kafkarebalance my-rebalance -n amq-streams-cruise     

wait until change to ready

oc run kafka-info1 -ti --image=quay.io/strimzi/kafka:latest-kafka-3.2.0 --rm=true --restart=Never -- /bin/bash -c "bin/kafka-topics.sh --bootstrap-server my-cluster-kafka-bootstrap:9092 --topic my-topic --describe
"
