#!/bin/bash

source ./utils.sh

# download helm-service chart
wget "https://github.com/keptn/keptn/releases/download/${KEPTN_VERSION}/helm-service-${KEPTN_VERSION}.tgz" -O "${HOME}/downloads/helm-service.tgz"

# download jmeter-service chart
wget "https://github.com/keptn/keptn/releases/download/${KEPTN_VERSION}/jmeter-service-${KEPTN_VERSION}.tgz" -O "${HOME}/downloads/jmeter-service.tgz"

mkdir ${HOME}/uniform-dist

mv ${HOME}/downloads/helm-service.tgz ${HOME}/uniform-dist/
mv ${HOME}/downloads/jmeter-service.tgz ${HOME}/uniform-dist/

cd ${HOME}/uniform-dist && python3 -m http.server &

KEPTN_API_HOSTNAME=$(echo "${KEPTN_ENDPOINT}" | awk -F[/] '{print $3}')

helm install helm-service http://0.0.0.0:8000/"helm-service.tgz" -n keptn-uniform --set remoteControlPlane.enabled=true --set remoteControlPlane.api.protocol=http --set remoteControlPlane.api.hostname="${KEPTN_API_HOSTNAME}" --set remoteControlPlane.api.token="${KEPTN_API_TOKEN}" --create-namespace
helm install jmeter-service http://0.0.0.0:8000/"jmeter-service.tgz" -n keptn-uniform --set remoteControlPlane.enabled=true --set remoteControlPlane.api.protocol=http --set remoteControlPlane.api.hostname="${KEPTN_API_HOSTNAME}" --set remoteControlPlane.api.token="${KEPTN_API_TOKEN}" --create-namespace

helm test jmeter-service -n keptn-uniform
helm test helm-service -n keptn-uniform