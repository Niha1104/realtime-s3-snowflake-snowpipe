-- Simple DQ task: checks nulls + negative amount in CURATED
CREATE OR REPLACE TASK CLAIMS_DEMO.OPS.TASK_DQ_CLAIMS
  WAREHOUSE = COMPUTE_WH
  SCHEDULE = '1 MINUTE'
AS
INSERT INTO CLAIMS_DEMO.OPS.DQ_RESULTS (run_ts, check_name, status, details)
SELECT
  CURRENT_TIMESTAMP(),
  'claims_basic_quality',
  IFF(bad_count = 0, 'PASS', 'FAIL'),
  'bad_count=' || bad_count
FROM (
  SELECT COUNT(*) AS bad_count
  FROM CLAIMS_DEMO.CURATED.FACT_CLAIMS
  WHERE claim_id IS NULL
     OR member_id IS NULL
     OR amount < 0
);

ALTER TASK CLAIMS_DEMO.OPS.TASK_DQ_CLAIMS RESUME;