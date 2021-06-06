## Cluster creds
To decrypt the kubeconfig.enc - use:
```
openssl enc -d -aes-256-cbc -in kubeconfig.enc -out kubeconfig
```

The password will be provided separately
