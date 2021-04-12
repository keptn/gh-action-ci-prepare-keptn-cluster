#!/bin/bash

source ./utils.sh

echo "Creating project ${KEPTN_PROJECT}"
keptn create project ${KEPTN_PROJECT} --shipyard=./assets/shipyard.yaml

keptn create service keptn --project=${KEPTN_PROJECT}
keptn create service dynatrace-service --project=${KEPTN_PROJECT}
keptn create service dynatrace-sli-service --project=${KEPTN_PROJECT}

# download the helm charts
wget "https://github.com/keptn/keptn/releases/download/${KEPTN_PROJECT_VERSION}/keptn-${KEPTN_PROJECT_VERSION}.tgz" -O "${HOME}/downloads/keptn.tgz"

keptn add-resource --project=${KEPTN_PROJECT} --service=keptn --all-stages --resource=${HOME}/downloads/keptn.tgz --resourceUri=helm.tgz