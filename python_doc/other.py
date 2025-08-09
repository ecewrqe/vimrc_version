import boto3

boto3.setup_default_session(region_name='ap-northeast-1')

def get_s3_client():
    return boto3.client('s3')

s3 = get_s3_client()
print(s3.list_buckets())
