bq rm -f -t sdp.sample_sustainability_data
bq load \
    --location=us-central1 \
    --autodetect \
    --source_format=CSV \
    sdp.sample_sustainability_data \
    gs://sdp-dev/sample_sustainability_data.csv

bq rm -f -t sdp.sample_sustainability_data_with_schema
bq load \
    --location=us-central1 \
    --source_format=CSV \
    --skip_leading_rows=1 \
    sdp.sample_sustainability_data_with_schema \
    "gs://sdp-dev/sample_sustainability_*.csv" \
    raw/sample_sustainability_data.json