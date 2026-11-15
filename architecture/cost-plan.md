# Football Data Analytics Platform --- Cost Plan

**Budget target:** €10/month\
**Region:** `eu-north-1`\
**Workload:** low-traffic public static site, daily data refresh

## Budget principle

€10/month is a target, not a guaranteed maximum. Do not deploy resources
until their current pricing, free-tier/plan eligibility, and related
charges have been checked.

## Cost drivers to review

  -----------------------------------------------------------------------
  Area                    Main billing drivers    Initial control
  ----------------------- ----------------------- -----------------------
  S3 data                 Stored GB, requests,    Small dataset; avoid
                          retrievals, versioning  unnecessary copies and
                                                  long retention

  Static website delivery Requests, data          Check current
                          transfer, selected      plan/allowances and
                          CloudFront              expected traffic
                          plan/features           

  Scheduled compute       Requests, execution     One short run daily; no
                          duration, memory        always-on instance

  Logs/monitoring         Log ingestion, storage, Set retention and avoid
                          alarms and metrics      excessive debug logging

  Analytics               Data scanned,           Defer Athena/Glue until
                          catalog/jobs if used    justified; keep queries
                                                  small

  API provider            Subscription tier and   Confirm a permitted
                          request limits          plan before integration

  Domain                  Registration and        Optional for the first
                          renewal                 demonstration
  -----------------------------------------------------------------------

## Required controls before deployment

1.  Set up an AWS Budget and notification threshold.
2.  Review actual spend regularly.
3.  Tag resources where practical, for example
    `Project=FootballDataAnalytics`.
4.  Avoid leaving test resources running.
5.  Document a cleanup procedure.
6.  Remember that budget alerts are not hard spending caps and may
    arrive after usage has occurred.

## Estimation worksheet

Fill in the values after selecting services and checking current prices.

  -----------------------------------------------------------------------
  Item              Expected usage    Price source      Estimated monthly
                                      checked?          cost
  ----------------- ----------------- ----------------- -----------------
  S3 data storage   Small dataset;    No                TBD
  and requests      daily writes and                    
                    website data                        
                    reads                               

  CloudFront        Low traffic       No                TBD
  delivery                                              

  Scheduled compute Approximately one No                TBD
                    execution per day                   

  Logs and alarms   Low-volume logs   No                TBD

  Analytics         Not included      No                TBD
  services          until justified                     

  API provider      To be selected    No                TBD

  Domain            Optional          No                TBD

  **Total**                                             **TBD --- must be
                                                        reviewed before
                                                        deployment**
  -----------------------------------------------------------------------

## Decision rule

If the estimate approaches or exceeds €10/month, simplify the design
before deploying: remove unnecessary services, reduce retention or query
volume, and defer optional features.
