# Create a trigger (this example uses a Cloud Source Repository)
REPO_NAME="sustainable-data-platform"
BRANCH_NAME="main"



gcloud beta builds triggers create cloud-source-repositories \
    --repo=$REPO_NAME \
    --branch-pattern="^main$" \
    --build-config="cloudbuild.yaml" \
    --name="manual-trigger-sdp" \
    --description="A manual trigger for a GitHub repo"

# Manually invoke the trigger
# gcloud builds submit --config=cloudbuild.yaml --branch=$BRANCH_NAME