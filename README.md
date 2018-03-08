# Kubernetes IAAS Request demo and provision


## Name Space

Namespaces are intended for use in environments with many users spread across multiple teams, or projects.

```
kubectl create -f namespace.yml
```

## Storage Class

A StorageClass provides a way for administrators to describe the “classes” of storage they offer.
Storage class can be requested through different IAAS with different **provisioner**
This example will use vSphere as an example.

[storage-class.yml](storage-class.yml)

```
kubectl create -f storage-class.yml
```
## Persistent Volume Claim (PVs)

A cluster administrator creates PVs which can binds to pods.
In vSphere Persistent Volume will be disks

[mysql-pv-claim.yml](mysql-pv-claim.yml)

```
kubectl create -f mysql-pv-claim.yml
```

## Create mysql deployment and service

```
kubectl create -f mysql.yml
```
Create mysql deployment with two instances and a InCluster Service (for app to connect to)
The mysql uses the persistent volume to store DB

## Create front end application

The sample app manages music albums and persists them to mysql database

```
kubectl create -f music.yml
```

This app contains 2 replicas (instances) to provide high availability
music app talks to mysql through [kubernetes dns](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/)

**mysql.iaas-request.svc.cluster.local**
**[name].[namespace].svc.cluster.local**

## Expose outside of the cluster through a load balancer

Assume K8s Cluster integrates with a Cloud with load balancer capability (GCP, AWS, NSX-T), it can request a load balancer on demand

```
kubectl create -f lb.yml
```

```
kubectl get service/music-external --namespace iaas-request
NAME             TYPE           CLUSTER-IP      EXTERNAL-IP      PORT(S)        AGE
music-external   LoadBalancer   10.100.200.99   10.193.148.235   80:32559/TCP   2h
```

Access the app through http://10.193.148.235

## Test persistent volume

* Create some albums manually with music app
* Delete both music and mysql pods

  **Do not delete the PV Claims**

  ```
  kubectl delete -f music.yml
  kubectl delete -f mysql.yml
  ```

* Create music and mysql pods again

  Access the app again and should be able to see the albums still exists
