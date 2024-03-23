

PROJECT_ID="sustainable-data-platform"
ENVIRONMENT="dev"
REGION="us-central1"
WORKFLOW_NAME="sample_${ENVIRONMENT}"

# deploy
gcloud workflows deploy ${WORKFLOW_NAME} \
    --project=${PROJECT_ID} \
    --location=${REGION} \
    --source=sample_workflow.yaml \
    --service-account=terraform@${PROJECT_ID}.iam.gserviceaccount.com