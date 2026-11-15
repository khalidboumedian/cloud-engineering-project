
import os
import json
import requests
import boto3

# Football API configuration
API_URL = "https://api.football-data.org/v4/competitions/BL1/matches"
API_TOKEN = os.getenv("FOOTBALL_DATA_API_TOKEN")

# AWS configuration
BUCKET_NAME = os.getenv("S3_BUCKET_NAME")
# Create AWS session using our SSO profile
session = boto3.Session(region_name="eu-north-1") 

s3 = session.client("s3")


def main():

    # 1. Check API token
    if not API_TOKEN:
        raise ValueError("Football API token is missing!")

    # 2. Retrieve Bundesliga matches
    print("Retrieving Bundesliga matches...")

    headers = {"X-Auth-Token": API_TOKEN}

    response = requests.get(
        API_URL,
        headers=headers,
        timeout=30
    )

    response.raise_for_status()
    data = response.json()

    print("Matches retrieved:", len(data.get("matches", [])))

    # 3. Save JSON locally
    os.makedirs("data/raw", exist_ok=True)

    local_file = "data/raw/matches.json"

    with open(local_file, "w", encoding="utf-8") as file:
        json.dump(data, file, indent=4, ensure_ascii=False)

    print("JSON file saved locally:", local_file)

    # 4. Upload JSON to S3
    s3_key = "raw/bundesliga/matches.json"

    print("Uploading data to Amazon S3...")

    s3.upload_file(
        local_file,
        BUCKET_NAME,
        s3_key
    )

    print("Upload successful!")
    print("S3 location:", s3_key)


if __name__ == "__main__":
    main()