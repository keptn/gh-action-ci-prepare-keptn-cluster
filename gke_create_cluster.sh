#!/bin/bash

echo "Cluster Name: $GKE_CLUSTER_NAME"

# configure gcloud
gcloud --quiet config set project "$GCLOUD_PROJECT_NAME"
gcloud --quiet config set container/cluster "$GKE_CLUSTER_NAME"
gcloud --quiet config set compute/zone "${CLOUDSDK_COMPUTE_ZONE}"

# clean up any nightly clusters
clusters=$(gcloud container clusters list --zone "$CLOUDSDK_COMPUTE_ZONE" --project "$GCLOUD_PROJECT_NAME")
if echo "$clusters" | grep "$GKE_CLUSTER_NAME"; then
    echo "Deleting nightly cluster ${GKE_CLUSTER_NAME} ..."
    gcloud container clusters delete "$GKE_CLUSTER_NAME" --zone "$CLOUDSDK_COMPUTE_ZONE" --project "$GCLOUD_PROJECT_NAME" --quiet
    echo "Finished deleting nightly cluster"
else
    echo "No nightly cluster need to be deleted"
fi

ADDONS="HorizontalPodAutoscaling,HttpLoadBalancing"

echo "Creating nightly cluster ${GKE_CLUSTER_NAME}"

# create a new cluster (Note: disk-size reduced to 25 GB to save resources; preemptible nodes used for cost savings)
# shellcheck disable=SC2140
gcloud beta container --project "$GCLOUD_PROJECT_NAME" clusters create "$GKE_CLUSTER_NAME" --zone "$CLOUDSDK_COMPUTE_ZONE" \
    --release-channel "None" --cluster-version "$GKE_VERSION" \
    --no-enable-basic-auth \
    --machine-type "n1-standard-4" --image-type "UBUNTU" --num-nodes "3" --preemptible --disk-type "pd-standard" --disk-size "25" \
    --metadata disable-legacy-endpoints=true \
    --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" \
    --enable-stackdriver-kubernetes --enable-ip-alias \
    --network "projects/$GCLOUD_PROJECT_NAME/global/networks/default" --subnetwork "projects/$GCLOUD_PROJECT_NAME/regions/$CLOUDSDK_REGION/subnetworks/default" \
    --no-enable-master-authorized-networks \
    --addons $ADDONS \
    --no-enable-autoupgrade --no-enable-autorepair \
    --enable-shielded-nodes \
    --labels owner=ci,expiry=auto-delete

# shellcheck disable=SC2181
if [[ $? != '0' ]]; then
    echo "gcloud cluster create failed"
    exit 1
fi
