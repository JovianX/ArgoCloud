#!/bin/bash -xf
argocd login $RELEASE_NAME-argocd-server --name default --username admin --password ArgoCloud --plaintext
export ADMIN_USER=$(echo $ADMIN_EMAIL | cut -f1 -d"@")
export PATCH="{\"data\" : {\"accounts.$ADMIN_USER\":\"apiKey, login\"}}"
kubectl patch cm argocd-cm --type merge -p "$PATCH" 
argocd account update-password --account=$ADMIN_USER --current-password=ArgoCloud --new-password $ADMIN_PASSWORD
kubectl patch cm argocd-cm --type merge -p "{\"data\": {\"admin.enabled\":\"false\"}}"
kubectl patch cm argocd-rbac-cm --type merge -p "{\"data\": {\"policy.csv\":\"g, $ADMIN_USER, role:admin\"}}"
