#!/bin/bash
expire_threshold_s=$1
secret_namespace=$2
secret_name=$3
heartbeat_url=$4
# certificates like the internal istio certificate use a different json data format like:
# .data['ca-cert\.pem']"
# This default'ed variable input allows for an override for these cases
secret_data_key="${5:-tls.crt}"

secret_data_key_escaped=$(echo "$secret_data_key" | sed -r 's/[\.]/\\./g')
echo "Escaped 'secret_data_key' = '$secret_data_key_escaped'"

set -e;
echo "Running 'kubectl get secret \"$secret_name\" --namespace \"$secret_namespace\" -o \"jsonpath={.data['$secret_data_key_escaped']}\"'"
raw_cert=$(kubectl get secret "$secret_name" --namespace "$secret_namespace" -o "jsonpath={.data['$secret_data_key_escaped']}")
decoded_cert=$(echo "$raw_cert" | base64 -d)
set +e;

echo "$decoded_cert" | openssl x509 --checkend "$expire_threshold_s" -noout
result=$?
if [ $result -ne 0 ]; then
    printf "Certificate '%s' will expire within %s seconds" "$secret_name" "$expire_threshold_s";
else
    set -x;
    curl -X POST "$heartbeat_url" --fail
    set +x;
    printf "\nSent heartbeat for '%s'" "$secret_name"
fi
