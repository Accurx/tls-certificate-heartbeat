#!/bin/bash
expire_threshold_s=$1

cert_array=("${@:2}")
for arg in "${cert_array[@]}"; do
  IFS=: read cert_name heartbeat_url <<< "$arg"
  set -x;
  kubectl get secret "$cert_name" --namespace default -o "jsonpath={.data['tls\.crt']}" | base64 -d | openssl x509 --checkend $expire_threshold_s -noout
  result=$?
  set +x;
  if [ $result -ne 0 ]; then
    printf "Certificate '%s' will expire within %s seconds" "$cert_name" "$expire_threshold_s";
  else
    set -x;
    curl -X POST "$heartbeat_url" --fail
    set +x;
    printf "\nSent heartbeat for '%s'" "$cert_name"
  fi
done

