https://developers.redhat.com/articles/2023/03/29/deploy-kafka-connect-container-using-strimzi#create_and_deploy_a_kafka_connect_container
oc login --insecure-skip-tls-verify
oc new-project kafka
oc apply -f kafka.yml
oc apply -f topic.yml

helm repo add bitnami https://charts.bitnami.com/bitnami
helm install mongodb bitnami/mongodb --set podSecurityContext.fsGroup="",containerSecurityContext.enabled=false,podSecurityContext.enabled=false,auth.enabled=false --version 13.6.0 -n kafka

oc apply -f producer.yml

oc create secret generic dockerhub --from-file=.dockerconfigjson=/Users/ckongman/.docker/config.json --type=kubernetes.io/dockerconfigjson -n kafka

oc apply -f mongodb-kc.yaml
oc apply -f mongodb-kcn.yaml

oc run --namespace kafka mongodb-client --rm --tty -i --restart='Never' --image docker.io/bitnami/mongodb:4.4.13-debian-10-r9 --command -- bash

mongo mongodb://mongodb:27017

use sampledb

db.samples.find();