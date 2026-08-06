# Real-Time S3 → Snowflake Snowpipe Pipeline

Event-driven ingestion of claims data from S3 into Snowflake — files land in S3, Snowpipe picks them up automatically, and a Stream + Task pair merges the changes into a curated table. No polling, no scheduled batch job checking whether new data showed up.

## Architecture

```
S3 (landing/claims/)
    │  new file uploaded
    ▼
S3 Event Notification → SQS
    │
    ▼
Snowpipe (AUTO_INGEST)
    │
    ▼
RAW table  ──▶  Stream (tracks changes)  ──▶  Task (MERGE)  ──▶  CURATED table
```

A CSV lands in `landing/claims/`, S3 fires an event notification into an SQS queue Snowpipe is listening on, and ingestion starts within seconds — not on the next scheduled run.

## Why SQS instead of polling

Checking S3 on a schedule means either wasted checks when nothing's changed, or staleness while you wait for the next run. Wiring S3's own event notifications into Snowpipe's queue means ingestion is triggered by the actual event, not a guess about how often new files might show up.

## Snowflake objects

| Object | Name |
|---|---|
| Database | `CLAIMS_DEMO` |
| RAW table | `CLAIMS_DEMO.RAW.CLAIMS_RAW` |
| CURATED table | `CLAIMS_DEMO.CURATED.FACT_CLAIMS` |
| Storage integration | `S3_INT_CLAIMS` |
| Stage | `CLAIMS_DEMO.OPS.S3_CLAIMS_STAGE` |
| Pipe | `CLAIMS_DEMO.OPS.PIPE_CLAIMS_AUTO` |
| Stream | `CLAIMS_DEMO.RAW.CLAIMS_STREAM` |
| Task | `CLAIMS_DEMO.OPS.TASK_MERGE_CLAIMS` |

## Running it

1. Create the S3 bucket and `landing/claims/` folder
2. Set up the Snowflake storage integration and external stage
3. Create the Snowpipe and connect the S3 event notification using the SQS ARN from `DESC PIPE`
4. Upload CSVs into `landing/claims/`
5. Confirm RAW and CURATED both update automatically

```sql
SELECT * FROM CLAIMS_DEMO.RAW.CLAIMS_RAW ORDER BY _ingested_at DESC;
SELECT * FROM CLAIMS_DEMO.CURATED.FACT_CLAIMS ORDER BY _ingested_at DESC;
```

## Stack

`AWS S3` · `SQS` · `Snowflake Storage Integration` · `Snowpipe (AUTO_INGEST)` · `Streams & Tasks` · `SQL`
