#!/bin/bash

####################################################
# Functions
####################################################
repeat() {
    echo
    for i in {1..120}; do
        echo -n "$1"
    done
    echo
}

create_projects() {
    echo

    for i in $( seq 1 $totalUsers )
    do
        echo ""
        echo "Logging in as user$i user to create projects..."
        echo

        oc login -u user$i -p $USER_PASSWORD --insecure-skip-tls-verify
        oc new-project user$i-amqstreams-quickstart
        oc new-project user$i-amqstreams-full
        oc new-project user$i-amqstreams-client
        oc delete limitranges --all -n user$i-amqstreams-quickstart
        oc delete limitranges --all -n user$i-amqstreams-full
        oc delete limitranges --all -n user$i-amqstreams-client
        repeat '-'
    done
    oc login -u admin -p $ADMIN_PASSWORD --insecure-skip-tls-verify
}

add_monitoring_edit_role_to_user()
{
    echo ""
    echo "Logging in as cluster administrator to add monitoring edit role to users..."
    echo

    oc login -u admin -p $ADMIN_PASSWORD --insecure-skip-tls-verify

    for i in $( seq 1 $totalUsers )
    do
        oc adm policy add-role-to-user monitoring-edit user$i -n user$i-amqstreams-quickstart
        oc adm policy add-role-to-user monitoring-edit user$i -n user$i-amqstreams-full
    done
    oc login -u admin -p $ADMIN_PASSWORD --insecure-skip-tls-verify
}

add_monitoring_view_role_to_grafana_serviceaccount() {

    echo ""
    echo "Logging in as cluster administrator to add monitoring view role to users..."
    echo

    oc login -u admin -p $ADMIN_PASSWORD --insecure-skip-tls-verify

    for i in $( seq 1 $totalUsers )
    do
        oc adm policy add-cluster-role-to-user cluster-monitoring-view -z grafana-serviceaccount -n user$i-amqstreams-full
    done
}

add_grafana_operator_to_project() {

    echo ""
    echo "Add Grafana Operator to userX-monitoring ..."
    echo

    oc login -u admin -p $ADMIN_PASSWORD --insecure-skip-tls-verify

    for i in $( seq 1 $totalUsers )
    do
        # if test $i -gt 2;
        # then
        echo
        echo "Installing grafana to project $i ..."
        echo

        cat ../manifest/operator-group.yml | sed "s#NAMESPACE#user$i-amqstreams-full#g" | oc apply -n user$i-amqstreams-full -f -
        oc apply -f ../manifest/grafana-subscription.yml -n user$i-amqstreams-full

        echo
        echo "Waiting for $operatorDescParam to be available..."
        echo
        # fi
    done
}

####################################################
# Main (Entry point)
####################################################
totalUsers=$1

create_projects
repeat '-'
add_monitoring_edit_role_to_user
repeat '-'
add_grafana_operator_to_project
repeat '-'
add_monitoring_view_role_to_grafana_serviceaccount
repeat '-'