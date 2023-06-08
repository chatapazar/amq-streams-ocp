# Kafka Users
## Kafka Users

Kafka users could be defined with ```KafkaUser``` definition. The user could includes
the authorization policies (ACLs) of the different resources in the Kafka cluster.

The following users could be defined:

* **admin-user-scram**: Super-user (using scram-sha-512 authentication) to administrate the Kafka
cluster. Definition [here](./users/admin-user-scram.yml).
* **admin-user-tls**: Super-user (using TLS authentication) to administrate the Kafka
cluster. Definition [here](./users/admin-user-tls.yml).
* **sample-user-tls**: User (using TLS authentication) to produce and consume records
from ```apps.samples.greetings``` topic. Definition [here](./users/sample-user-tls.yml).
* **sample-streams-user-tls**: User to produce and consume records to and from ```app.samples.greetings.*``` topics.
Definition [here](./users/sample-streams-user-tls.yml).

To create the users:

```shell
oc apply -f ./users/
```

This command will show the status of the Kafka Users:

```shell
❯ oc get kafkausers
NAME                      CLUSTER     AUTHENTICATION   AUTHORIZATION   READY
admin-user-scram          event-bus   scram-sha-512                    True
admin-user-tls            event-bus   tls                              True
sample-streams-user-tls   event-bus   tls              simple          True
sample-user-tls           event-bus   tls              simple          True
```

To describe a Kafka User:

```shell
oc get kafkauser admin-user-scram -o yaml
```

Each user will have its own secret with the credentials defined it:

```shell
❯ oc get secret admin-user-scram -o yaml
apiVersion: v1
data:
  password: ZHYwV1V5eUx6Y09x
kind: Secret
metadata:
  labels:
    app.kubernetes.io/instance: sample-user-scram
    app.kubernetes.io/managed-by: strimzi-user-operator
    app.kubernetes.io/name: strimzi-user-operator
    app.kubernetes.io/part-of: strimzi-sample-user-scram
    strimzi.io/cluster: event-bus
    strimzi.io/kind: KafkaUser
  name: sample-user-scram
  namespace: amq-streams-mirror
type: Opaque
```

To decrypt the password:

```shell
❯ oc get secret admin-user-scram -o jsonpath='{.data.password}' | base64 -d
adKQsEuXKVEV
```



References:

* [Using the User Operator](https://strimzi.io/docs/operators/latest/using.html#assembly-using-the-user-operator-str)
