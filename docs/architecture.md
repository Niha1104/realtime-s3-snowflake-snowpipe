# Architecture

## End-to-End Flow
1. Upload CSV to `s3://claims-realtime-niharika-2026/landing/claims/`
2. S3 Event Notification sends ObjectCreated events to SQS (Snowpipe queue)
3. Snowpipe AUTO_INGEST loads into `CLAIMS_DEMO.RAW.CLAIMS_RAW`
4. Stream captures new rows from RAW
5. Task MERGE runs every minute and updates `CLAIMS_DEMO.CURATED.FACT_CLAIMS`

## Snowflake Objects
- Storage Integration: `S3_INT_CLAIMS`
- Stage: `CLAIMS_DEMO.OPS.S3_CLAIMS_STAGE`
- Pipe: `CLAIMS_DEMO.OPS.PIPE_CLAIMS_AUTO`
- Stream: `CLAIMS_DEMO.RAW.CLAIMS_STREAM`
- Task: `CLAIMS_DEMO.OPS.TASK_MERGE_CLAIMS`# Architecture
