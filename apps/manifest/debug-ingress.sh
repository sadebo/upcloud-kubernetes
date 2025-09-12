#!/bin/bash
NS=default
ING=flaskredis-ingress
TLS_SECRET=flaskredis-tls
ING_CTRL_NS=ingress-nginx
NODE_IP=$(kubectl get nodes -o wide | awk 'NR==2{print $6}')  # first node InternalIP
NODEPORT=$(kubectl get svc ingress-nginx-controller -n $ING_CTRL_NS -o jsonpath='{.spec.ports[?(@.name=="https")].nodePort}')
LB=$(kubectl get svc ingress-nginx-controller -n $ING_CTRL_NS -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

echo "🔍 Checking Ingress TLS config..."
kubectl get ingress $ING -n $NS -o yaml | grep tls: -A5

echo -e "\n🔍 Checking Secret $TLS_SECRET..."
kubectl get secret $TLS_SECRET -n $NS -o jsonpath='{.data.tls\.crt}' | base64 -d | openssl x509 -noout -issuer -subject -dates || echo "❌ Secret missing or invalid"

echo -e "\n🔄 Restarting ingress-nginx..."
kubectl rollout restart deploy -n $ING_CTRL_NS

echo -e "\n⏳ Waiting 30s for ingress-nginx to reload..."
sleep 30

echo -e "\n🌐 Curl test against NodePort $NODE_IP:$NODEPORT"
curl -vk https://$NODE_IP:$NODEPORT -H "Host: flaskredis.parallelservicesllc.com" 2>&1 | grep -E "subject:|issuer:"

echo -e "\n🌐 Curl test against LoadBalancer $LB"
curl -vk https://flaskredis.parallelservicesllc.com 2>&1 | grep -E "subject:|issuer:"

