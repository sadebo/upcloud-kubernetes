#!/bin/bash
NS=default
TLS_SECRET=flaskredis-tls
ING_NS=ingress-nginx
NODE_IP=94.237.85.116     # pick any node external IP
NODEPORT=30598            # HTTPS NodePort from your svc
LB_HOST=flaskredis.parallelservicesllc.com

echo "🔍 Checking TLS secret $TLS_SECRET..."
kubectl get secret $TLS_SECRET -n $NS -o jsonpath='{.data.tls\.crt}' | base64 -d | openssl x509 -noout -subject -issuer -dates

echo -e "\n🌐 Testing NodePort $NODE_IP:$NODEPORT"
curl -vk https://$NODE_IP:$NODEPORT -H "Host: $LB_HOST" 2>&1 | grep -E "subject:|issuer:"

echo -e "\n🌐 Testing LoadBalancer Host $LB_HOST"
curl -vk https://$LB_HOST 2>&1 | grep -E "subject:|issuer:"

