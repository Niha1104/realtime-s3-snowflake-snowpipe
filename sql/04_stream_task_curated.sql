-- Stream on RAW
CREATE OR REPLACE STREAM CLAIMS_DEMO.RAW.CLAIMS_STREAM
  ON TABLE CLAIMS_DEMO.RAW.CLAIMS_RAW;

-- Task to merge into CURATED every 1 minute
CREATE OR REPLACE TASK CLAIMS_DEMO.OPS.TASK_MERGE_CLAIMS
  WAREHOUSE = COMPUTE_WH
  SCHEDULE = '1 MINUTE'
AS
MERGE INTO CLAIMS_DEMO.CURATED.FACT_CLAIMS t
USING (
  SELECT claim_id, member_id, provider_id, service_date, amount, updated_at, _ingested_at
  FROM CLAIMS_DEMO.RAW.CLAIMS_STREAM
) s
ON t.claim_id = s.claim_id
WHEN MATCHED THEN UPDATE SET
  member_id = s.member_id,
  provider_id = s.provider_id,
  service_date = s.service_date,
  amount = s.amount,
  updated_at = s.updated_at,
  _ingested_at = s._ingested_at
WHEN NOT MATCHED THEN INSERT
  (claim_id, member_id, provider_id, service_date, amount, updated_at, _ingested_at)
VALUES
  (s.claim_id, s.member_id, s.provider_id, s.service_date, s.amount, s.updated_at, s._ingested_at);

-- Enable task
ALTER TASK CLAIMS_DEMO.OPS.TASK_MERGE_CLAIMS RESUME;

-- Optional: run once immediately (no waiting)
-- EXECUTE TASK CLAIMS_DEMO.OPS.TASK_MERGE_CLAIMS;