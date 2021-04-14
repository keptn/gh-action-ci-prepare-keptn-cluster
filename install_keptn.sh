#!/bin/bash

source ${{ github.action_path }}/utils.sh

echo "{}" > creds.json # empty credentials file
keptn install --endpoint-service-type=LoadBalancer --creds=creds.json --verbose

keptn version

# install public-gateway.istio-system
kubectl apply -f - <<EOF
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: public-gateway
  namespace: istio-system
spec:
  selector:
    istio: ingressgateway # use Istio default gateway implementation
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - "*"
EOF

# set ingress-hostname params
INGRESS_IP=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "INGRESS_IP=$INGRESS_IP"
kubectl create configmap -n keptn ingress-config --from-literal=ingress_hostname_suffix=${INGRESS_IP}.nip.io --from-literal=ingress_port=80 --from-literal=ingress_protocol=http --from-literal=ingress_gateway=public-gateway.istio-system -oyaml --dry-run | kubectl replace -f -
# restart helm-service
kubectl delete pod -n keptn -lapp.kubernetes.io/name=helm-service
sleep 15

echo "Verifying that services and namespaces have been created"

# verify the deployments within the keptn namespace (for keptn control plane)
verify_deployment_in_namespace "api-gateway-nginx" keptn
verify_deployment_in_namespace "api-service" keptn
verify_deployment_in_namespace "bridge" keptn
verify_deployment_in_namespace "configuration-service" keptn
verify_deployment_in_namespace "lighthouse-service" keptn
verify_deployment_in_namespace "shipyard-controller" keptn
verify_deployment_in_namespace "statistics-service" keptn

# verify deployments for continuous delivery
verify_deployment_in_namespace "remediation-service" keptn
verify_deployment_in_namespace "approval-service" keptn

# verify the datastore deployments
verify_deployment_in_namespace "mongodb" keptn
verify_deployment_in_namespace "mongodb-datastore" keptn