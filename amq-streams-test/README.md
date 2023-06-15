# Basic AMQ Streams on OCP

- install AMQ Streams 2.2 Operator (recommend version 2.2 for LTS)

- New Openshift Project

```bash
oc login --insecure-skip-tls-verify with admin
oc new-project amq-streams-test
```

- Create Kafka
oc apply -f kafka-metric.yml
oc apply -f my-clsuter-kafka.yml 
oc apply -f topics/
oc apply -f users/

oc new-project streams-grafana
oc delete limitranges --all -n streams-grafana
oc apply -f operator-group.yml -n streams-grafana
oc apply -f grafana-subscription.yml -n streams-grafana
oc get pods -n streams-grafana
# create application workload monitoring configmap
oc apply -f user-workload-monitoring.yml

oc get po -n openshift-user-workload-monitoring

cat ../strimzi-0.29.0/examples/metrics/prometheus-install/strimzi-pod-monitor.yaml | sed "s#myproject#amq-streams-test#g" | oc apply -n amq-streams-test -f -

check metrics strimzi_resources in project amq-streams-test

oc apply -f grafana.yml
oc apply -f grafana-sa.yml
oc apply -f grafana-crb.yml
export TOKEN=$(oc create token --duration=999h -n streams-grafana grafana-serviceaccount)
echo $TOKEN

cat grafana-datasource.yml | sed "s#TOKEN#$TOKEN#g" | oc apply -n streams-grafana -f -

open grafana in streams-grafana
user: admin/admin
test datasources
import dashboard (kafka, zookeeper, exporter) from strimzi-0.29.0/examples/metrics/grafana-dashboards download folder

oc project amq-streams-test
oc apply -f 01-deployment-producer.yml
oc apply -f 02-deployment-consumer.yml

oc delete -f 01-deployment-producer.yml
oc delete -f 02-deployment-consumer.yml

client example code
https://github.com/strimzi/client-examples/tree/main


oc new-project amq-streams-client
oc get secret my-cluster-cluster-ca-cert -o yaml -n amq-streams-test > source-secrets/my-cluster-cluster-ca-cert.yaml
oc get secret sample-user-tls -o yaml -n amq-streams-test > source-secrets/sample-user-tls.yaml

remove info in metadata tag except name & namespace
change namespace to amq-streams-client

oc apply -f source-secrets

oc apply -f 03-deployment-producer.yml
oc apply -f 04-deployment-consumer.yml

oc delete -f 03-deployment-producer.yml
oc delete -f 04-deployment-consumer.yml

test streams
oc project amq-streams-test
oc apply -f 05-deployment-producer.yml
oc apply -f 06-deployment-streams.yml
06 apply -f 07-deployment-consumer.yml

oc delete -f 05-deployment-producer.yml
oc delete -f 06-deployment-streams.yml
06 delete -f 07-deployment-consumer.yml