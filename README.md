# sspies8684 helm repository
 
## Add helm repository

```bash
$ helm repo add sspies8684 https://raw.githubusercontent.com/sspies8684/helm-repo/master
```

## Launch helm chart postgres-cluster

Choose storage class
```bash
$ kubectl get sc
NAME                 PROVISIONER   AGE
hostpath (default)   hostpath      24d
```

Launch chart
```bash
$ helm install --namespace test -n db sspies8684/postgres-cluster --set 'storage.class=hostpath'
```

Make cluster public and read ip
```bash
$ kubectl patch --namespace test service/db-pgpool -p '{"spec":{"type":"LoadBalancer"}}'

$ kubectl get --namespace test service db-pgpool
NAME        TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
db-pgpool   LoadBalancer   10.102.22.187   1.2.3.4     5432:31834/TCP   2m42s

$ PGPASSWORD="changeme!" psql -h 1.2.3.4 -U user mydb
psql (10.10 (Ubuntu 10.10-0ubuntu0.18.04.1), server 10.3 (Debian 10.3-1.pgdg90+1))
Type "help" for help.

mydb=# 
```
