
import json
import os
import urllib.parse
import boto3

# Connect to Amazon S3
s3 = boto3.client("s3")

# Get the bucket name from the Lambda environment variable
BUCKET_NAME = os.environ["BUCKET_NAME"]


def lambda_handler(event, context):

    print("Starting Bundesliga data processing...")

    for record in event["Records"]:

        # Get the S3 bucket and uploaded file
        bucket = record["s3"]["bucket"]["name"]
        key = urllib.parse.unquote_plus(
            record["s3"]["object"]["key"]
        )

        print("Processing file:", key)

        # Download the raw JSON file from S3
        response = s3.get_object(
            Bucket=bucket,
            Key=key
        )

        raw_data = json.loads(
            response["Body"].read().decode("utf-8")
        )

        # Extract only the information we need
        processed_matches = []

        for match in raw_data.get("matches", []):

            full_time = match.get("score", {}).get("fullTime", {})

            processed_match = {
                "match_id": match.get("id"),
                "date": match.get("utcDate"),
                "matchday": match.get("matchday"),
                "status": match.get("status"),
                "home_team": match.get("homeTeam", {}).get("name"),
                "away_team": match.get("awayTeam", {}).get("name"),
                "home_score": full_time.get("home"),
                "away_score": full_time.get("away")
            }

            processed_matches.append(processed_match)

        # Create the processed JSON structure
        output_data = {
            "competition": "Bundesliga",
            "season": raw_data.get("filters", {}).get("season"),
            "total_matches": len(processed_matches),
            "matches": processed_matches
        }

        # Upload the processed data to S3
        output_key = "processed/matches.json"

        s3.put_object(
            Bucket=BUCKET_NAME,
            Key=output_key,
            Body=json.dumps(
                output_data,
                ensure_ascii=False,
                indent=4
            ).encode("utf-8"),
            ContentType="application/json"
        )

        print("Processed matches:", len(processed_matches))
        print("Uploaded processed file:", output_key)

    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "Bundesliga data processed successfully"
        })
    }
