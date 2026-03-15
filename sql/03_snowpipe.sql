-- Create Snowpipe (AUTO_INGEST)
CREATE OR REPLACE PIPE CLAIMS_DEMO.OPS.PIPE_CLAIMS_AUTO
  AUTO_INGEST = TRUE
AS
COPY INTO CLAIMS_DEMO.RAW.CLAIMS_RAW
  (claim_id, member_id, provider_id, service_date, amount, updated_at)
FROM (
  SELECT
    $1, $2, $3,
    TO_DATE($4),
    TO_NUMBER($5, 10, 2),
    TO_TIMESTAMP_NTZ($6)
  FROM @CLAIMS_DEMO.OPS.S3_CLAIMS_STAGE
)
ON_ERROR = 'CONTINUE';

-- Get SQS notification channel ARN (use this in S3 event notification)
DESC PIPE CLAIMS_DEMO.OPS.PIPE_CLAIMS_AUTO;