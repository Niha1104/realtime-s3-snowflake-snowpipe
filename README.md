# Real-Time S3 → Snowflake Snowpipe Pipeline (RAW → CURATED)

## Project Overview
This project demonstrates a real-time, event-driven data pipeline using AWS S3 and Snowflake Snowpipe. When a CSV file is uploaded to an S3 folder, Snowpipe auto-ingests the data into a Snowflake RAW table. A Snowflake Stream + Task then merges incremental changes into a CURATED table.

## Architecture
S3 (landing/claims/) → S3 Event Notification → SQS (Snowpipe queue) → Snowflake Snowpipe → RAW table → Stream → Task MERGE → CURATED table

## Tech Stack
- AWS S3
- S3 Event Notifications → SQS
- Snowflake Storage Integration + External Stage
- Snowflake Snowpipe (AUTO_INGEST)
- Snowflake Streams + Tasks
- SQL

## Snowflake Objects (Example Names)
- Database: `CLAIMS_DEMO`
- RAW table: `CLAIMS_DEMO.RAW.CLAIMS_RAW`
- CURATED table: `CLAIMS_DEMO.CURATED.FACT_CLAIMS`
- Integration: `S3_INT_CLAIMS`
- Stage: `CLAIMS_DEMO.OPS.S3_CLAIMS_STAGE`
- Pipe: `CLAIMS_DEMO.OPS.PIPE_CLAIMS_AUTO`
- Stream: `CLAIMS_DEMO.RAW.CLAIMS_STREAM`
- Task: `CLAIMS_DEMO.OPS.TASK_MERGE_CLAIMS`

## How to Run (High Level)
1. Create S3 bucket and folder: `landing/claims/`
2. Create Snowflake integration + stage
3. Create Snowpipe and connect S3 event notification (SQS ARN from `DESC PIPE`)
4. Upload CSV files into `landing/claims/`
5. Validate RAW and CURATED tables update automatically

## Validation Queries
```sql
SELECT * FROM CLAIMS_DEMO.RAW.CLAIMS_RAW ORDER BY _ingested_at DESC;
SELECT * FROM CLAIMS_DEMO.CURATED.FACT_CLAIMS ORDER BY _ingested_at DESC;# Real-Time S3 → Snowflake Snowpipe
