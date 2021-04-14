#!/bin/bash

source ${BASE_PATH}/utils.sh

echo "Creating project ${KEPTN_PROJECT}"
keptn create project ${KEPTN_PROJECT} --shipyard=${BASE_PATH}/assets/shipyard.yaml

echo "Onboarding Keptn to ${KEPTN_PROJECT}"
keptn create service keptn --project=${KEPTN_PROJECT}
# download the helm charts
wget "https://github.com/keptn/keptn/releases/download/${KEPTN_PROJECT_VERSION}/keptn-${KEPTN_PROJECT_VERSION}.tgz" -O "${HOME}/downloads/keptn.tgz"
keptn add-resource --project=${KEPTN_PROJECT} --service=keptn --all-stages --resource=${HOME}/downloads/keptn.tgz --resourceUri=helm/keptn.tgz

if [[ $ONBOARD_DYNATRACE_SERVICE == "true" ]]; then
  echo "Onboarding the dynatrace-service"
  keptn create service dynatrace-service --project=${KEPTN_PROJECT}
  wget "https://github.com/keptn-contrib/dynatrace-service/releases/download/${DYNATRACE_SERVICE_VERSION}/dynatrace-service-${DYNATRACE_SERVICE_VERSION}.tgz" -O "${HOME}/downloads/dynatrace-service.tgz"
  keptn add-resource --project=${KEPTN_PROJECT} --service=dynatrace-service --all-stages --resource=${HOME}/downloads/dynatrace-service.tgz --resourceUri=helm/dynatrace-service.tgz
fi

if [[ $ONBOARD_DYNATRACE_SERVICE == "true" ]]; then
  echo "Onboarding the dynatrace-sli-service"
  keptn create service dynatrace-sli-service --project=${KEPTN_PROJECT}
  wget "https://github.com/keptn-contrib/dynatrace-sli-service/releases/download/${DYNATRACE_SLI_SERVICE_VERSION}/dynatrace-sli-service-${DYNATRACE_SLI_SERVICE_VERSION}.tgz" -O "${HOME}/downloads/dynatrace-sli-service.tgz"
  keptn add-resource --project=${KEPTN_PROJECT} --service=dynatrace-sli-service --all-stages --resource=${HOME}/downloads/dynatrace-sli-service.tgz --resourceUri=helm/dynatrace-sli-service.tgz
fi


