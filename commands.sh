#!/bin/bash


gcloud auth list
gcloud auth revoke --all
gcloud init

# Set your Google Cloud project ID
PROJECT_ID="sustainable-data-platform"
# PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')
PROJECT_NUMBER="324237649233"
echo "Project ID: $PROJECT_ID"


gcloud services enable cloudbuild.googleapis.com
gcloud services enable workflows.googleapis.com
gcloud services enable cloudfunctions.googleapis.com
gcloud services enable bigquery.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable storage.googleapis.com
gcloud services enable iam.googleapis.com 
gcloud services enable composer.googleapis.com

# Create a service account for sdp-admin
gcloud iam service-accounts create sdp-admin \
    --display-name "SDP admin account" \
    --project "$PROJECT_ID"

# # Bind the Cloud Build Admin role to the service account
gcloud projects add-iam-policy-binding "$PROJECT_ID" \
    --member="serviceAccount:sdp-admin@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/owner" \
    --project "$PROJECT_ID"

# # Bind the Service Account User role to the service account
gcloud projects add-iam-policy-binding "$PROJECT_ID" \
    --member="serviceAccount:sdp-admin@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/iam.serviceAccountUser" \
    --project "$PROJECT_ID"

# Create a service account key
gcloud iam service-accounts keys create ~/sdp-admin-key.json \
    --iam-account=sdp-admin@$PROJECT_ID.iam.gserviceaccount.com



echo "Project Number: $PROJECT_NUMBER"
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member=serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com \
  --role=roles/workflows.admin


gcloud iam service-accounts add-iam-policy-binding \
  $PROJECT_NUMBER-compute@developer.gserviceaccount.com \
  --member=serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com \
  --role=roles/iam.serviceAccountUser

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member=serviceAccount:sdp-admin@$PROJECT_ID.iam.gserviceaccount.com \
    --role=roles/logging.logWriter


gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:sdp-admin@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/iam.serviceAccountUser"


gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:sdp-admin@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/bigquery.jobUser"


gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member="serviceAccount:sdp-admin@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/bigquery.dataEditor"


gcloud projects add-iam-policy-binding sustainable-data-platform \
  --member="serviceAccount:sdp-admin@sustainable-data-platform.iam.gserviceaccount.com" \
  --role="roles/cloudfunctions.invoker"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:service-324237649233@cloudcomposer-accounts.iam.gserviceaccount.com" \
  --role="roles/composer.serviceAgent"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:service-324237649233@cloudcomposer-accounts.iam.gserviceaccount.com" \
  --role="roles/composer.ServiceAgentV2Ext"


# upload the sample data to the bucket
gsutil mb -l us-central1 -c STANDARD gs://sdp-dev/
gsutil cp raw/sample_sustainability_data.csv gs://sdp-dev/sample_sustainability_data.csv