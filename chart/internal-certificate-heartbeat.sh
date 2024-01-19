#!/bin/bash
expire_threshold_s=$1
secret_name=$2
heartbeat_url=$3
secret_jsonpath="${4:.data['tls/.crt']}"

set -x;
kubectl get secret "$secret_name" --namespace default -o "jsonpath={$secret_jsonpath}" | base64 -d | openssl x509 --checkend $expire_threshold_s -noout
set +x;

result=$?
if [ $result -ne 0 ]; then
    printf "Certificate '%s' will expire within %s seconds" "$secret_name" "$expire_threshold_s";
else
    set -x;
    curl -X POST "$heartbeat_url" --fail
    set +x;
    printf "\nSent heartbeat for '%s'" "$secret_name"
fi

