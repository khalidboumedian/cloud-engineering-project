# Football Analytics Platform

## Overview

A serverless, event-driven football data platform built on AWS and managed with Terraform.

The platform collects Bundesliga match data from an external football API, processes it using AWS Lambda, stores the results in Amazon S3, and makes the processed data available to a static website through Amazon CloudFront.

## Architecture

The project consists of two main phases.

### Phase 1 – Data Collection and Processing

1. Amazon EventBridge triggers the data collection process daily.
2. AWS Lambda retrieves Bundesliga match data from an external API.
3. Raw JSON data is stored in Amazon S3.
4. An S3 event notification triggers a second Lambda function.
5. The processor Lambda processes the data and stores the results in S3.

### Phase 2 – Website and Data Delivery

1. A static website is hosted in Amazon S3.
2. Amazon CloudFront delivers the website over HTTPS.
3. CloudFront uses a separate S3 origin for processed football data.
4. The website retrieves the processed JSON data through CloudFront.

## AWS Services

| Service | Purpose |
|---|---|
| Amazon S3 | Store raw data, processed data, and website files |
| AWS Lambda | Collect and process football data |
| Amazon EventBridge | Schedule daily data collection |
| Amazon CloudFront | Deliver the website and processed data |
| AWS IAM | Manage permissions between AWS services |
| Amazon CloudWatch | Store Lambda logs and support troubleshooting |

## Infrastructure as Code

Terraform is used to provision and manage the AWS infrastructure.

## Security and Design Decisions

- Private S3 buckets.
- CloudFront Origin Access Control (OAC).
- IAM roles and policies for Lambda permissions.
- HTTPS delivery through CloudFront.
- Event-driven processing without continuously running servers.

## Technologies

- AWS
- Terraform
- Python
- HTML, CSS and JavaScript
- Git and GitHub

## Project Status

The main data collection, processing, and website delivery components have been implemented.

## What I Learned

- Designing event-driven serverless architectures.
- Integrating AWS Lambda with Amazon S3 and EventBridge.
- Managing AWS infrastructure with Terraform.
- Configuring CloudFront with private S3 origins.
- Working with IAM permissions and CloudWatch logs.
- Troubleshooting AWS services and event-driven workflows.

## Future Improvements

- Improve automated testing.
- Add CI/CD automation.
- Expand football data analysis and visualizations.

---

**Note:** This is a learning and portfolio project. AWS resources may not always be deployed or publicly accessible.