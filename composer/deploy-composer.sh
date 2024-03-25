
AIRFLOW_INSTANCE_NAME="sdp-dev"
PROJECT_ID="sustainable-data-platform"
PROJECT_NUMBER="324237649233"
LOCATION="us-central1"
IMAGE_VERSION="composer-2.5.4-airflow-2.5.3"
SERVICE_ACCOUNT="terraform@sustainable-data-platform.iam.gserviceaccount.com"


gcloud composer environments create $AIRFLOW_INSTANCE_NAME \
    --location=$LOCATION \
    --image-version=$IMAGE_VERSION \
    --service-account=$SERVICE_ACCOUNT




