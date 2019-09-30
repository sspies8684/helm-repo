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
$ helm install --namespace test sspies8684/postgres-cluster --set 'storage.class=hostpath'
```
