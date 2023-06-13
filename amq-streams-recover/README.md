oc login --insecure-skip-tls-verify
oc apply -f storage-retain.yml
oc new-project myproject
oc apply -f kafka-retain.yaml
oc apply -f topic.yml
deploy obsidiandynamics/kafdrop
set KAFKA_BROKERCONNECT=my-cluster-kafka-bootstrap:9092
port 9000:9000
oc apply -f 01-deployment-producer.yml
oc delete -f 01-deployment-producer.yml

oc delete project myproject
oc get pv
oc get pvc

oc new-project myproject
oc get pv
update volumeName in pvc.yml
oc apply -f pvc.yml
delete claimRef in all pv
oc apply -f topic.yml
oc apply -f kafka-retain.yaml

deploy obsidiandynamics/kafdrop
set KAFKA_BROKERCONNECT=my-cluster-kafka-bootstrap:9092
port 9000:9000