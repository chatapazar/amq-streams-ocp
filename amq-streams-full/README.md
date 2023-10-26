# Advanced Red Hat AMQ Streams on OpenShift


## Login to Red Hat OpenShift Container Platform

- Login to OpenShift Web Console (get URL from instructor)
- Input your username and password (get username/password from instructor)
  
  ![](images/q1.png)

- Click skip tour
    
  ![](images/q2.png)

- Workshop provide 2 workspace, userX-amqstreams-full & userX-amqstreams-quickstart, for this workshop, click 'userX-amqstreams-full'
  
  ![](images/q3.png)

- after select project 'userX-amqstreams-full', select Topology in left menu bar. 

  ![](images/f1.png)

## Setup Web Terminal and Git 

- a
  
  ![](images/f2.png)
  ![](images/f3.png)
  ![](images/f4.png)
  ![](images/f5.png)
  ![](images/f6.png)
  ![](images/f7.png)
  ![](images/f8.png)

  - Create Metric ConfigMap, Kafka Cluster, Kafka Topic and Kafka User

    ```bash
    oc project user1-amqstreams-full
    cd ~/amq-streams-ocp/amq-streams-full/manifest
    oc apply -f kafka-metric.yml
    oc apply -f my-clsuter-kafka.yml 
    oc apply -f topics/
    oc apply -f users/
    ```

- View Kafka Cluster

  ![](images/kafka-1.png)

- View Kafka Topics
  
  ![](images/kafka-2.png)

- View Kafka Users
  
  ![](images/kafka-3.png)

## Create Monitoring for AMQ Streams



- View Grafana Operator Install Complete!
  
  ![](images/kafka-4.png)

- check application workload monitoring install

- create monitor service for kafka component (zookeeper, kafka, exporter, etc.)

    ```sh
    cd ~/amq-streams-ocp/amq-streams-full
    cat ../strimzi-0.29.0/examples/metrics/prometheus-install/strimzi-pod-monitor.yaml | sed "s#myproject#userX-amqstreams-full#g" | oc apply -n userX-amqstreams-full -f -
    ```

- check metrics "strimzi_resources" in project amq-streams-test, observe menu, metrics, custom query (wait 2-3 minutes for openshift get metric to user workload monitoring)

    ![](images/kafka-5.png)

- create grafana, service account, cluster role binding and token for connect 
  
    ```bash
    cd ~/amq-streams-ocp/amq-streams-full/manifest
    cat grafana.yml | sed "s#NAMESPACE#user1-amqstreams-full#g" | oc apply -n user1-amqstreams-full -f -
    cat grafana-sa.yml | sed "s#NAMESPACE#user1-amqstreams-full#g" | oc apply -n user1-amqstreams-full -f -
    cat grafana-crb.yml | sed "s#NAMESPACE#user1-amqstreams-full#g" | oc apply -n user1-amqstreams-full -f -
    export TOKEN=$(oc create token --duration=999h -n user1-amqstreams-full grafana-serviceaccount)
    echo $TOKEN
    ```

- create grafana datasource to thanos
  
    ```bash
    oc project user1-amqstreams-full
    cat grafana-datasource.yml | sed "s#TOKEN#$TOKEN#g" | oc apply -n user1-amqstreams-full -f -
    ```

- open grafana web ui in streams-grafana
  
  ![](images/kafka-6.png)

- user: admin/admin

  ![](images/kafka-7.png)

- test datasources

  ![](images/kafka-8.png)

  ![](images/kafka-9.png)

- import dashboard (kafka, zookeeper, exporter) from strimzi-0.29.0/examples/metrics/grafana-dashboards download folder
  
  ![](images/kafka-10.png)

  ![](images/kafka-11.png)

- View Zookeeper Monitor
  
  ![](images/kafka-12.png)

- View Kafka Monitor
  
  ![](images/kafka-13.png)

- Veiw Kafka Exporter Monitor
    
  ![](images/kafka-14.png)

## AMQ Streams Test Client

- Create Producer & Consumer with my-topic Topic

    ```bash
    oc project amq-streams-test
    oc apply -f 01-deployment-producer.yml
    oc apply -f 02-deployment-consumer.yml
    ```

- Producer Log
  
  ![](images/kafka-15.png)

- Consumer Log    
  
  ![](images/kafka-16.png)

- Delete Producer & Consumer

    ```bash
    oc delete -f 01-deployment-producer.yml
    oc delete -f 02-deployment-consumer.yml
    ```

- client example code
https://github.com/strimzi/client-examples/tree/main

## Kafak Client connect with Route
  
- Prepare New Project and get cert & user from kafka project
   
    ```bash
    oc new-project amq-streams-client
    oc get secret my-cluster-cluster-ca-cert -o yaml -n amq-streams-test > source-secrets/my-cluster-cluster-ca-cert.yaml
    oc get secret sample-user-tls -o yaml -n amq-streams-test > source-secrets/sample-user-tls.yaml
    ```

- remove info in metadata tag except name & namespace and change namespace to amq-streams-client

    ```yaml
    metadata:
      name: sample-user-tls     
      namespace: amq-streams-client
    ```

- create cert & user secret in project

    ```bash
    oc apply -f source-secrets
    ```

- create producer and consumer deployment

    ```bash
    oc apply -f 03-deployment-producer.yml
    oc apply -f 04-deployment-consumer.yml
    ```

- View producer log
  
  ![](images/kafka-17.png)

- View consumer log

  ![](images/kafka-18.png)

- remove producer and consumer deployment

    ```bash
    oc delete -f 03-deployment-producer.yml
    oc delete -f 04-deployment-consumer.yml
    ```

## Test Kafka Streams

- Create Kafka Producer --> Kafka Streams --> Kafka Consumer
  
    ```bash
    oc project amq-streams-test
    oc apply -f 05-deployment-producer.yml
    oc apply -f 06-deployment-streams.yml
    oc apply -f 07-deployment-consumer.yml
    ```

- View Producer Log
  
  ![](images/kafka-19.png)

- View Streams Log
  
  ![](images/kafka-20.png)

- View Consumer Log

  ![](images/kafka-21.png)

- Remove Producer, Streams, Consumer
  
    ```bash
    oc delete -f 05-deployment-producer.yml
    oc delete -f 06-deployment-streams.yml
    oc delete -f 07-deployment-consumer.yml
    ```