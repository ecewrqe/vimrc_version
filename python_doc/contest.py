
import os
import boto3
from botocore.session import Session
from moto import mock_aws
import pytest


@pytest.fixture
def s3_mock():
    with mock_aws():
        s3 = boto3.client('s3', region_name='ap-northeast-1')
        bucket1 = "test-bucket"
        bucket2 = "test-bucket-2"
        bucket3 = 'dst-bucket'
        for bucket in [bucket1, bucket2, bucket3]:
            s3.create_bucket(
                Bucket=bucket,
                CreateBucketConfiguration={
                    "LocationConstraint": "ap-northeast-1"
                }
            )

        tsv_content = "id\tname\n1\tTest User\n2\tAnother User"
        s3.put_object(Bucket=bucket1, Key="test_file_01.tsv", Body=tsv_content)

        s3.put_object(Bucket=bucket2, Key="AA/BB/CC/DD/")
        s3.put_object(Bucket=bucket3, Key="AA/BB/CC/DD/")

        yield {
            "s3": s3,
            "bucket1": bucket1,
            "bucket2": bucket2,
            "bucket3": bucket3
        }

@mock_aws
@pytest.fixture
def ssm_mock():
    os.environ.pop("AWS_ACCESS_KEY_ID", None)
    os.environ.pop("AWS_SECRET_ACCESS_KEY", None)
    os.environ.pop("AWS_SESSION_TOKEN", None)
    session = Session()
    session.set_credentials(None, None, None)

    with mock_aws():
        ssm = boto3.client("ssm", region_name='ap-northeast-1')

        ssm.put_parameter(
            Name="/dev/database/host",
            Value="postgres",
            Type="String"
        )

        yield {"ssm": ssm}

@mock_aws
@pytest.fixture
def ssm_mock_log(request):
    log_level = request.param

    os.environ.pop("AWS_ACCESS_KEY_ID", None)
    os.environ.pop("AWS_SECRET_ACCESS_KEY", None)
    os.environ.pop("AWS_SESSION_TOKEN", None)
    session = Session()
    session.set_credentials(None, None, None)

    with mock_aws():
        ssm = boto3.client("ssm", region_name='ap-northeast-1')
        ssm.put_parameter(
            Name="/dev/cwl/logging_level",
            Value=log_level,
            Type="String"
        )
        yield {"ssm": ssm}

@mock_aws
@pytest.fixture
def secrets_manager_mock():
    with mock_aws():