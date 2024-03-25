
# Set the region, entry point, service account, project, and stage bucket
CLOUD_FUNCTION_NAME="sdp-dev-ingestion"
REGION="us-central1"
SERVICE_ACCOUNT="terraform@sustainable-data-platform.iam.gserviceaccount.com"
PROJECT="sustainable-data-platform"
ENTRY_POINT="entry_point"


# Deploy the cloud function
gcloud functions deploy $CLOUD_FUNCTION_NAME \
--runtime=python39 \
--region=$REGION \
--trigger-http \
--allow-unauthenticated \
--entry-point=$ENTRY_POINT \
--gen2 \
--service-account=$SERVICE_ACCOUNT \
--source ./src \
--project=$PROJECT \
--min-instances 1 \
--memory=256Mi