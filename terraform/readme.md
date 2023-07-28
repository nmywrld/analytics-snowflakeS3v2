# Phase 1: Build Components
- An S3 staging bucket to serve as an external stage to Snowflake. This is where raw data files land.
- An AWS Role that grants read access to the staging bucket. Snowflake assumes this role to access the external stage.
- An Event Notification gets triggered whenever new objects are placed in the staging bucket. It sends the details about the event to an SNS topic.
- An SNS (Simple Notification Service) topic receives the events and forwards them to the subscribed SQS (Simple Queue Service) in Snowflake.

# Phase 2: Build Components
- A storage integration allows users to load or unload data from an external stage without supplying credentials. It generates an IAM user that is granted the required permissions to access resources in AWS.
- The database and the corresponding schema that is to be created is where the external stage and destination table are going to be placed.
- An external stage references a cloud storage location outside of Snowflake. In this example, the external stage is mapped to an S3 bucket.


all successfully done up to here

next steps:
- take data from the snow stage convert it and place it into tables
  - create tables if not already created.
- build pipe for incoming data

2 options from here
1. use airflow to automate ingestion
   - create tables if not created
   - schedule ingestion 
   - loop through new objects based on sns 
2. use a json matrix to build a pipe for every prefix:table combo
