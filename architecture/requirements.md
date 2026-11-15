# Football Data Analytics Platform --- Requirements and Initial Design

**Status:** Draft v1\
**AWS Region:** `eu-north-1` (Stockholm)\
**Monthly AWS budget target:** €10\
**Data refresh:** Daily\
**Audience:** Public website\
**Infrastructure as Code:** Terraform

## 1. Project objective

Build a public Football Data Analytics Platform that collects football
data from an external provider, processes it with Python, and publishes
useful football statistics through a website.

The project is intended to provide practical experience with AWS,
Terraform, Python, cloud security, automation, monitoring, testing, and
CI/CD. The finished GitHub repository should demonstrate the design
decisions and implementation of a realistic junior Cloud/DevOps
portfolio project.

## 2. Scope for the first version

### In scope

-   Collect a small, useful set of football data from an external API.
-   Run data collection once per day.
-   Preserve original API responses for debugging and reprocessing.
-   Transform data into a simple format suitable for analytics and
    website consumption.
-   Publish precomputed statistics through a public static website.
-   Provision and manage AWS infrastructure with Terraform.
-   Apply least-privilege access, private storage, encryption, logging,
    and cost controls.
-   Add automated tests and CI checks as the project develops.
-   Document setup, deployment, operation, troubleshooting, and cleanup.

### Not required for the first version

-   Live scores or real-time updates.
-   User accounts or personalized dashboards.
-   A continuously running EC2 server.
-   A dynamic backend API unless a later requirement justifies it.
-   Advanced analytics services before the data volume requires them.

## 3. Functional requirements

  -----------------------------------------------------------------------
  ID                      Requirement             Acceptance criteria
  ----------------------- ----------------------- -----------------------
  FR-01                   Retrieve football data  The ingestion code can
                                                  retrieve a supported
                                                  dataset from the
                                                  selected provider.

  FR-02                   Daily refresh           The collection workflow
                                                  can be scheduled to run
                                                  once per day.

  FR-03                   Preserve raw data       Original API responses
                                                  can be stored
                                                  separately from
                                                  processed outputs.

  FR-04                   Process data            Python validates and
                                                  transforms source data
                                                  into a documented
                                                  output format.

  FR-05                   Calculate statistics    The project produces at
                                                  least one useful
                                                  football statistic or
                                                  table.

  FR-06                   Public presentation     Visitors can access the
                                                  website and view
                                                  published statistics
                                                  without AWS
                                                  credentials.

  FR-07                   Infrastructure as Code  Required AWS resources
                                                  are defined in
                                                  Terraform and can be
                                                  reviewed with
                                                  `terraform plan`.

  FR-08                   Testability             Core data
                                                  transformation logic
                                                  has automated tests.

  FR-09                   Observability           Pipeline execution logs
                                                  and failures can be
                                                  investigated.

  FR-10                   Reproducibility         The README explains how
                                                  to configure, deploy,
                                                  test, and clean up the
                                                  project.
  -----------------------------------------------------------------------

## 4. Non-functional requirements

### Cost

-   Target AWS spend is no more than approximately €10 per month under
    the intended low-traffic workload.
-   This is a budget target, not a guaranteed hard cap.
-   Estimate costs before deploying each service.
-   Prefer short-lived, pay-per-use compute where it fits.
-   Avoid always-on compute for the initial version.
-   Set up billing alerts and review actual charges.
-   Remember that billing alerts may be delayed and do not automatically
    stop resources.

### Security

-   Keep the data S3 bucket private.
-   Enable S3 Block Public Access and encryption.
-   Do not place API keys or AWS credentials in source code or GitHub.
-   Use least-privilege IAM policies and roles.
-   Expose only explicitly approved website assets and published
    statistics.
-   Do not make the whole data bucket public merely because the website
    is public.
-   Use HTTPS for the public website.
-   Protect Terraform state and do not commit state files or plans to
    Git.

### Availability and freshness

-   Daily freshness is sufficient; real-time data is not required.
-   The website should remain usable if the latest data refresh fails,
    where practical.
-   The site should indicate or tolerate stale data rather than implying
    a successful refresh when the pipeline failed.

### Maintainability

-   Keep infrastructure, application code, tests, and architecture
    documentation separated.
-   Prefer understandable solutions over unnecessary service complexity.
-   Record significant architecture decisions and revisit them when
    requirements change.

## 5. Initial architecture direction

This is a proposed starting design. Services will be confirmed as we
implement each requirement.

1.  **External football data API** --- provides fixtures, results,
    teams, and/or statistics.
2.  **Scheduled Python ingestion** --- retrieves and validates data
    daily.
3.  **Amazon S3 data bucket** --- stores raw and processed data.
4.  **Static website** --- displays precomputed statistics to public
    visitors.
5.  **CloudFront** --- candidate for HTTPS public delivery while keeping
    the S3 origin private.
6.  **Terraform** --- provisions and updates the infrastructure.
7.  **CloudWatch and billing tools** --- support troubleshooting and
    cost awareness.
8.  **GitHub Actions** --- later validates code and Terraform changes.

Potential services such as Lambda, EventBridge, Athena, Glue, API
Gateway, DynamoDB, and Cognito are not mandatory by default. Add them
only when they meet a documented requirement and fit the budget.

## 6. Storage decision

**Decision:** Start with one private S3 data bucket containing two
prefixes:

-   `raw/` --- original API responses.
-   `processed/` --- validated data and precomputed statistics.

### Rationale

-   Fewer resources and simpler initial Terraform configuration.
-   Prefixes provide clear organization without requiring separate
    buckets.
-   For a small portfolio workload, one data bucket is sufficient
    initially.

### Trade-offs and controls

-   Prefixes are organizational conventions, not security boundaries by
    themselves.
-   IAM and resource policies must restrict access appropriately.
-   Keep S3 Block Public Access enabled.
-   CloudFront should serve only approved public assets/data, not raw
    API responses.
-   Consider a separate website bucket if that makes the publication
    boundary easier to secure or operate.

## 7. Website decision

**Decision:** Start with a static website using precomputed data.

### Rationale

-   Daily data updates do not require a backend request for every
    visitor.
-   Static files reduce application and operational complexity.
-   The website can consume generated JSON or other static files.
-   This fits the €10/month target better than an always-running server
    for a small workload.

### Trade-offs

-   Data is refreshed on the daily schedule rather than in real time.
-   User-specific queries and dynamic features are limited.
-   If dynamic functionality becomes necessary, evaluate a backend API
    as a later enhancement.

## 8. Budget and cost controls

The €10/month target covers the overall AWS workload, not just storage.
Actual costs depend on region, service configuration, API usage, website
traffic, requests, logs, and data scanned.

Before enabling a service: 1. Identify its billing dimensions and
free-tier/plan eligibility. 2. Estimate expected requests, runtime,
storage, and data transfer. 3. Check whether the service creates related
costs. 4. Decide how to monitor usage. 5. Record the decision and verify
the actual bill after deployment.

Initial cost-control measures: - Keep the dataset and retention period
small. - Run ingestion once daily. - Avoid continuously running
instances. - Keep Athena/Glue and other analytics services out of the
initial deployment unless justified. - Configure AWS Budgets alerts. -
Review Cost Explorer or billing information regularly. - Destroy
temporary resources when no longer needed. - Do not treat a budget alert
as an automatic spending limit.

## 9. Data provider and licensing

Before choosing the API provider, verify: - The free or low-cost plan
supports the required competitions and fields. - Daily collection is
within request limits. - The provider's terms allow the intended use. -
Publicly displaying derived statistics and/or source data is
permitted. - Attribution requirements are documented. - API keys can be
stored securely.

The provider and exact competition/season remain open decisions.

## 10. Initial implementation milestones

1.  Review the local environment and confirm Python works consistently.
2.  Verify AWS identity and determine the minimum IAM permissions
    required.
3.  Decide how Terraform state will be stored and protected.
4.  Implement a private S3 data bucket in Terraform.
5.  Apply security settings and verify access.
6.  Upload a small sample football dataset.
7.  Build and test the Python ingestion process.
8.  Automate the daily workflow.
9.  Generate precomputed statistics.
10. Publish the static website securely.
11. Add CI checks, monitoring, cost review, and final documentation.

## 11. Definition of done

The initial project is complete when: - Infrastructure can be created
and reviewed using Terraform. - Data can be collected, validated,
stored, and processed. - A daily workflow runs and exposes useful logs
for troubleshooting. - The public website displays the intended
statistics. - Raw data and secrets are not publicly exposed. - Automated
tests and basic CI checks pass. - The deployment, cost controls, and
cleanup steps are documented.

## 12. Known current setup

-   AWS CLI installed and AWS identity verification succeeded.
-   Configured AWS region: `eu-north-1`.
-   Terraform installed.
-   Git and GitHub repository are set up.
-   Existing project folders include `terraform/`, `src/`, `tests/`,
    `architecture/`, and `.github/workflows/`.
-   The current AWS IAM user received `AccessDenied` for
    `s3:ListAllMyBuckets`. This only confirms that listing all buckets
    is not permitted; it does not prove all S3 operations are denied.
    Determine the required least-privilege permissions before
    deployment.
-   Python launcher `py` worked, while `python` and `python3` commands
    previously did not. Verify/fix the local Python command before
    building the ingestion code.

## 13. Open items

-   Select the football API provider and confirm licensing.
-   Choose the initial competition, season, and dataset.
-   Estimate costs for the selected services in `eu-north-1`.
-   Choose and document the Terraform state approach.
-   Confirm the exact S3-to-CloudFront publication design.
-   Decide which statistics provide the most useful first demonstration.
