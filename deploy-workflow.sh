

PROJECT_ID="sustainable-data-platform"
ENVIRONMENT="dev"
REGION="us-central1"
WORKFLOW_NAME="myFirstWorkflow_${ENVIRONMENT}"


# delete
try
    gcloud workflows delete ${WORKFLOW_NAME} --location=${REGION} --quiet
except
    echo "An error occurred while deleting the workflow."
end

# deploy
gcloud workflows deploy ${WORKFLOW_NAME} \
    --project=${PROJECT_ID} \
    --location=${REGION} \
    --source=workflow.yaml \
    --service-account=terraform@${PROJECT_ID}.iam.gserviceaccount.com