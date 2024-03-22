BRANCH_NAME="main"
BUILD_CONFIG_FILE="cloudbuild.yaml"
PROJECT_ID="sustainable-data-platform"
SERVICE_ACCOUNT=projects/$PROJECT_ID/serviceAccounts/terraform@$PROJECT_ID.iam.gserviceaccount.com
ENVIRONMENT="dev"
REPO=https://www.github.com/shaikhzhas/gcp-de-projects
REPO_TYPE=GITHUB
REGION="global"

echo $SERVICE_ACCOUNT

# delete
gcloud beta builds triggers delete "sdp-${ENVIRONMENT}" --region=$REGION --quiet
gcloud beta builds triggers create manual \
    --name="sdp-${ENVIRONMENT}" \
    --build-config=$BUILD_CONFIG_FILE \
    --repo=$REPO \
    --repo-type=$REPO_TYPE \
    --branch=$BRANCH_NAME \
    --description="Trigger for Cloud Build" \
    --region=$REGION