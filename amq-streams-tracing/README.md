
```sh
oc login --insecure-skip-tls-verify
install Red Hat OpenShift distributed tracing platform Operator
oc new-project amq-streams-tracing
oc delete limitranges --all

oc apply -f kafka.yaml
oc apply -f my-topic.yml

oc apply -f my-jaeger.yml
oc apply -f producer.yml
oc apply -f consumer.yml

```
