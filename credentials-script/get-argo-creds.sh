#!/bin/bash
set -e
set -o pipefail


SERVICE_ACCOUNT_NAME="argocloud-admin"
NAMESPACE="argocloud"

TARGET_FOLDER="/tmp/argocloud"
SECRET_FILE_NAME="/tmp/argocloud/secret-${SERVICE_ACCOUNT_NAME}-${NAMESPACE}.yaml"

create_target_folder() {
    mkdir -p "${TARGET_FOLDER}"
}

test_current_kubeconfig() {
    kubectl get svc kubernetes -oname
}

test_generated_kubeconfig() {
    printf "done"
}

create_namespace() {
    kubectl create namespace "${NAMESPACE}"
}

create_service_account() {
    kubectl create sa "${SERVICE_ACCOUNT_NAME}" --namespace "${NAMESPACE}"
}

create_cluster_role_binding() {
    kubectl create clusterrolebinding ${SERVICE_ACCOUNT_NAME} \
    --clusterrole cluster-admin --user "system:serviceaccount:${NAMESPACE}:${SERVICE_ACCOUNT_NAME}"
}

get_secret_name_from_service_account() {
    SECRET_NAME=$(kubectl get sa "${SERVICE_ACCOUNT_NAME}" --namespace="${NAMESPACE}" -o jsonpath="{ .secrets[0].name }")
}

extract_ca_crt_from_secret() {
    CADATA=$(kubectl get secret --namespace "${NAMESPACE}" "${SECRET_NAME}" -o jsonpath="{ .data.ca\.crt"})
}

get_user_token_from_secret() {
    USER_TOKEN=$(kubectl get secret --namespace "${NAMESPACE}" "${SECRET_NAME}" -o jsonpath="{ .data.token }" | base64 -d)
}

print_creds() {
    context=$(kubectl config current-context)

    CLUSTER_NAME=$(kubectl config get-contexts "$context" | awk '{print $3}' | tail -n 1)

    ENDPOINT=$(kubectl config view \
    -o jsonpath="{.clusters[?(@.name == \"${CLUSTER_NAME}\")].cluster.server}")
    
    echo "-------------------------------------------------------------------------"
    echo "   When prompted - enter these parameters on ArgoCloud web interface     "
    echo "-------------------------------------------------------------------------"
    echo "==="
    echo "Server: "
    echo "${ENDPOINT}"
    echo "==="
    echo  "Bearer token:"
    echo "${USER_TOKEN}"
    echo "==="
    echo "CA Data:"
    echo "${CADATA}"
    echo ""
}

echo 
echo "Generate ArgoCD credentials for your cluster"
echo
echo "This script generates Bearer Token Credentials that allow full administrative access to your cluster"
#echo "Please note that this creates a Kubernetes service account 'argocloud-admin' with *CLUSTER-ADMIN* role in the 'argocloud-system' namespace."
echo

read -p "Proceed?[Y/n]" -n 1 -r

echo   
if [[ $REPLY =~ ^[Yy]$ ]]
then
    test_current_kubeconfig
    create_target_folder
    create_namespace || true 
    create_service_account || true
    create_cluster_role_binding || true
    get_secret_name_from_service_account
    extract_ca_crt_from_secret
    get_user_token_from_secret
    print_creds
fi
