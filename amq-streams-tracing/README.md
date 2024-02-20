
```sh
oc login --insecure-skip-tls-verify
install red hat elasticsearch operator
install Red Hat OpenShift distributed tracing platform Operator 
oc new-project amq-streams-tracing
oc delete limitranges --all

oc apply -f kafka.yaml
oc apply -f my-topic.yml


new otel
oc apply -f my-otlp.yml
oc apply -f otel-producer.yml
oc apply -f otel-consumer.yml

old open tracing

oc apply -f my-jaeger.yml
oc apply -f producer.yml
oc apply -f consumer.yml

```
