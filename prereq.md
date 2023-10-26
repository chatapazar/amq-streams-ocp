# Prerequisite for Workshop

## Install Red Hat AMQ Streams 2.2 Operator (recommend version 2.2 for LTS)

- Request OpenShift Container Platform from demo.redhat.com 

- Go to Openshift Console, with Cluster Admin, select Operators, Operator Hub and Search with "AMQ Streams"
  
    ![](images/prereq-1.png)

- Select AMQ Streams porvided by Red Hat, Click Install

    ![](images/prereq-2.png)

- select update channel to amq-streams-2.2.x
- select installation mode : All namespaces on the cluster (default)
- keep default installed namespace to "openshift-operators"
- select Update approval : Automatic
- click install 

    ![](images/prereq-3.png)

- Wait Until Install Complete

    ![](images/prereq-4.png)

    ![](images/prereq-5.png)

## Install Custom Metrics Autoscaler
- Go to Openshift Console, with Cluster Admin, select Operators, Operator Hub and Search with "Custome Metrics"
    
    ![](images/prereq-6.png)

- click Install

    ![](images/prereq-7.png)

- leave all default, click install
  
    ![](images/prereq-8.png)

- wait until install complete

    ![](images/prereq-9.png)

- select project openshift-keda, click tab "KedaController", click Create KedaController

    ![](images/prereq-10.png)

- leave all default value, click Create    

    ![](images/prereq-11.png)

- wait until status change to "Phase: Installation Succeeded"

    ![](images/prereq-12.png)


## Setup Application Workload Monitoring

- login oc client with cluster admin user
- Create application workload monitoring configmap

    ```bash
    cd amq-streams-test
    oc apply -f user-workload-monitoring.yml
    oc get po -n openshift-user-workload-monitoring
    ```

- wait until all pod running

    ```bash
    NAME                                  READY   STATUS    RESTARTS   AGE
    prometheus-operator-cf59f9bdc-zmw4v   2/2     Running   0          3h16m
    prometheus-user-workload-0            6/6     Running   0          3h16m
    prometheus-user-workload-1            6/6     Running   0          3h16m
    thanos-ruler-user-workload-0          4/4     Running   0          3h16m
    thanos-ruler-user-workload-1          4/4     Running   0          3h16m
    ```

## Setup User Workshop

- Clone this repository to your computer then go to [script](script/) directory.

- Export lab user password and cluster admin password (the passwords should be there in the mail sent from RHDP). Then run [lab-user-provisioner.sh](script/lab-user-provisioner.sh) script with number of lab users as the script argument.

   For example, provisioning 5 lab users:

   ```sh
   export USER_PASSWORD=openshift
   export ADMIN_PASSWORD=r3dh4t1!
   ./lab-user-provisioner.sh 5
   ```

   **Following projects/namespaces will be created for each user:**
   * user*X*-amqstreams-quickstart
   * user*X*-amqstreams-full