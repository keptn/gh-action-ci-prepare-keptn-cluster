#!/bin/bash

source ${BASE_PATH}/utils.sh

function onboard_service() {
  SERVICE_NAME=$1
  PROJECT_NAME=$2
  HELM_CHART_URL=$3

  echo "Onboarding ${SERVICE_NAME} to ${PROJECT_NAME}"
  keptn create service ${SERVICE_NAME} --project=${PROJECT_NAME}
  wget ${HELM_CHART_URL} -O "${HOME}/downloads/${SERVICE_NAME}.tgz"
  keptn add-resource --project=${PROJECT_NAME} --service=${SERVICE_NAME} --all-stages --resource=${HOME}/downloads/${SERVICE_NAME}.tgz --resourceUri=helm/${SERVICE_NAME}.tgz

}

echo "Creating project ${KEPTN_PROJECT}"
keptn create project ${KEPTN_PROJECT} --shipyard=${BASE_PATH}/assets/shipyard.yaml

onboard_service "keptn" ${KEPTN_PROJECT} "https://github.com/keptn/keptn/releases/download/${KEPTN_PROJECT_VERSION}/keptn-${KEPTN_PROJECT_VERSION}.tgz"
onboard_service "helm-service" ${KEPTN_PROJECT} "https://github.com/keptn/keptn/releases/download/${KEPTN_PROJECT_VERSION}/helm-service-${KEPTN_PROJECT_VERSION}.tgz"
onboard_service "jmeter-service" ${KEPTN_PROJECT} "https://github.com/keptn/keptn/releases/download/${KEPTN_PROJECT_VERSION}/jmeter-service-${KEPTN_PROJECT_VERSION}.tgz"

if [[ $ONBOARD_DYNATRACE_SERVICE == "true" ]]; then
  echo "Onboarding the dynatrace-service"
  onboard_service "dynatrace-service" ${KEPTN_PROJECT} "https://github.com/keptn-contrib/dynatrace-service/releases/download/${DYNATRACE_SERVICE_VERSION}/dynatrace-service-${DYNATRACE_SERVICE_VERSION}.tgz"
fi

if [[ $ONBOARD_DYNATRACE_SERVICE == "true" ]]; then
  onboard_service "dynatrace-sli-service" ${KEPTN_PROJECT} "https://github.com/keptn-contrib/dynatrace-sli-service/releases/download/${DYNATRACE_SLI_SERVICE_VERSION}/dynatrace-sli-service-${DYNATRACE_SLI_SERVICE_VERSION}.tgz"
fi


