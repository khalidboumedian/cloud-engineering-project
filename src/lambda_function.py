
import json
import os
import urllib.request
import boto3
from datetime import datetime, timezone

# Football API
API_URL = "https://api.football-data.org/v4/competitions/BL1/matches"

# Read configuration from Lambda environment variables
BUCKET_NAME = os.environ["BUCKET_NAME"]
API_TOKEN = os.environ["FOOTBALL_DATA_API_TOKEN"]

# AWS automatically provides credentials through the Lambda IAM role
s3 = boto3.client("s3")


def lambda_handler(event, context):

    print("Starting Bundesliga data collection...")

    # 1. Request data from football-data.org
    request = urllib.request.Request(
        API_URL,
        headers={"X-Auth-Token": API_TOKEN}
    )

    with urllib.request.urlopen(request, timeout=30) as response:
        data = json.loads(response.read().decode("utf-8"))

    matches_count = len(data.get("matches", []))
    print("Matches retrieved:", matches_count)

    # 2. Create a dated S3 object key
    timestamp = datetime.now(timezone.utc).strftime("%Y-%m-%d")
    s3_key = f"raw/bundesliga/matches-{timestamp}.json"

    # 3. Upload JSON to S3
    s3.put_object(
        Bucket=BUCKET_NAME,
        Key=s3_key,
        Body=json.dumps(data).encode("utf-8"),
        ContentType="application/json"
    )

    print("Uploaded to S3:", s3_key)

    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "Bundesliga data uploaded successfully",
            "matches": matches_count,
            "s3_key": s3_key
        })
    }
