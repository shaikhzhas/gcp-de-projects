bq rm -f -t sustainable-data-platform:sdp.table_bq
bq mk --table sustainable-data-platform:sdp.table_bq bq/table/schema.json

bq rm -f -t sustainable-data-platform:sdp.view_bq
bq mk --view "SELECT id, value FROM sdp.table_bq" sustainable-data-platform:sdp.view_bq

bq query --use_legacy_sql=false \
'''
CREATE OR REPLACE PROCEDURE `sustainable-data-platform.sdp.sp_bq`(input_id INT64)
BEGIN
  SELECT * FROM `sustainable-data-platform.sdp.table_bq` WHERE id = input_id;
END;
'''