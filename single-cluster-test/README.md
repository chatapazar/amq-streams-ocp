- install AMQ Streams 2.2 Operator
oc login --insecure-skip-tls-verify with admin
oc new-project amq-streams-test
create sample kafka cluster - use default config 'my-cluster'
create topic 'my-topic' - use default config


deploy obsidiandynamics/kafdrop
set KAFKA_BROKERCONNECT=my-cluster-kafka-bootstrap:9092
port 9000:9000

```shell
oc run kafka-producer -ti --image=quay.io/strimzi/kafka:latest-kafka-3.2.0 --rm=true --restart=Never -- /bin/bash -c "bin/kafka-console-producer.sh --broker-list my-cluster-kafka-bootstrap:9092 --topic my-topic
"
```
exit after input 'a','b','c',...,'j'

show offset in kafdrop

oc apply -f 02-deployment-consumer.yml

show log get all
show lag in kafdrop

oc delete -f 02-deployment-consumer.yml

run consumer again
oc apply -f 02-deployment-consumer.yml
show don't consume

start producer again and put 'k','l','m',...,'t'
oc apply -f 02-deployment-consumer.yml
view log show 'k' to 't' consume by app
oc delete -f 02-deployment-consumer.yml



