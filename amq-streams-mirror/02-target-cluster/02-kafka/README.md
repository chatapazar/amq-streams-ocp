# Apache Kafka Cluster

Login as normal user:

```shell
oc login -u user
```

The Kafka Cluster is described in the ```event-bus-kafka.yml``` file.

You can deploy or update the Kafka cluster with the following command:

```shell
oc project amq-streams-mirror
oc delete limitranges --all
oc apply -f kafka-metrics-new.yml
oc apply -f event-bus-kafka-noauth-metric.yml
```

This cluster is available with the following services:

```shell
$ oc get svc
NAME                         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                               AGE
event-bus-kafka-bootstrap    ClusterIP   172.30.20.58    <none>        9091/TCP,9092/TCP,9093/TCP            84s
event-bus-kafka-brokers      ClusterIP   None            <none>        9090/TCP,9091/TCP,9092/TCP,9093/TCP   84s
event-bus-zookeeper-client   ClusterIP   172.30.119.58   <none>        2181/TCP                              3m5s
event-bus-zookeeper-nodes    ClusterIP   None            <none>        2181/TCP,2888/TCP,3888/TCP            3m5s
```

The ```event-bus-kafka-bootstrap``` service is used to connect the producers and consumers with this cluster.

* Port ```9092```: Unsecured port
* Port ```9093```: Secured port
* Port ```9404```: Metrics port

We could check the status of this Apache Kafka cluster with:

```shell
❯ oc get kafka
NAME        DESIRED KAFKA REPLICAS   DESIRED ZK REPLICAS   READY   WARNINGS
event-bus   3                        3                     True    
```

To describe the Kafka:

```shell
oc get kafka event-bus -o yaml
```

The following pods will be deployed:

```shell
❯ oc get pod
NAME                                                READY   STATUS    RESTARTS   AGE
event-bus-entity-operator-5fb8465fd5-s4zs2          3/3     Running   0          55s
event-bus-kafka-0                                   1/1     Running   0          2m30s
event-bus-kafka-1                                   1/1     Running   0          2m30s
event-bus-kafka-2                                   1/1     Running   0          2m30s
event-bus-kafka-exporter-6f7ffb5b8b-dzslg           1/1     Running   0          14s
event-bus-zookeeper-0                               1/1     Running   0          4m11s
event-bus-zookeeper-1                               1/1     Running   0          4m11s
event-bus-zookeeper-2                               1/1     Running   0          4m11s
strimzi-cluster-operator-v0.26.0-747fcdb666-rjf6w   1/1     Running   0          6m7s
```

References:

deploy obsidiandynamics/kafdrop
set KAFKA_BROKERCONNECT=event-bus-kafka-bootstrap:9092
port 9000:9000

oc new-project streams-grafana
oc delete limitranges --all -n streams-grafana
oc apply -f operator-group.yml -n streams-grafana
oc apply -f grafana-subscription.yml -n streams-grafana
oc get pods -n streams-grafana
# create application workload monitoring configmap
oc apply -f user-workload-monitoring.yml

oc get po -n openshift-user-workload-monitoring

cat ../../../strimzi-0.29.0/examples/metrics/prometheus-install/strimzi-pod-monitor.yaml | sed "s#myproject#amq-streams-mirror#g" | oc apply -n amq-streams-mirror -f -

check metrics strimzi_resources in project amq-streams-mirror

oc apply -f grafana.yml
oc apply -f grafana-sa.yml
oc apply -f grafana-crb.yml
export TOKEN=$(oc create token --duration=999h -n streams-grafana grafana-serviceaccount)
echo $TOKEN

cat << EOF | oc apply -f -
apiVersion: integreatly.org/v1alpha1
kind: GrafanaDataSource
metadata:
  name: grafanadatasource
  namespace: streams-grafana
spec:
  name: middleware.yaml
  datasources:
    - name: Prometheus
      type: prometheus
      access: proxy
      url: https://thanos-querier.openshift-monitoring.svc.cluster.local:9091
      basicAuth: false
      basicAuthUser: internal
      isDefault: true
      version: 1
      editable: true
      jsonData:
        tlsSkipVerify: true
        timeInterval: "5s"
        httpHeaderName1: "Authorization"
      secureJsonData:
        httpHeaderValue1: "Bearer $TOKEN"
EOF

open grafana in streams-grafana
user: admin/admin
test datasources
import dashboard (kafka, zookeeper, exporter) from strimzi-0.29.0/examples/metrics/grafana-dashboards download folder


* [Kafka Cluster Configuration](https://strimzi.io/docs/operators/latest/using.html#assembly-config-kafka-str)
