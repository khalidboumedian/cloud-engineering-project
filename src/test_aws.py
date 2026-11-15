import boto3

session = boto3.Session(
    profile_name="FootballAnalytics-Terraform-S3-266735807125",
    region_name="eu-north-1"
)

sts = session.client("sts")

identity = sts.get_caller_identity()

print("Boto3 connection successful!")
print("AWS Account:", identity["Account"])
print("AWS User:", identity["Arn"])