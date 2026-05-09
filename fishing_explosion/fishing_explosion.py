import requests
import time
import re
from faker import Faker
import json

get_headers = {
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
    "Accept-Language": "en,ja;q=0.9,zh;q=0.8,zh-CN;q=0.7",
    "Sec-Ch-Ua": '"Google Chrome";v="147", "Not.A/Brand";v="8", "Chromium";v="147"',
    "Sec-Ch-Ua-Mobile": '?0',
    "Sec-Ch-Ua-Platform": '"macOS"',
    "Sec-Fetch-Dest": 'document',
    "Sec-Fetch-Mode": "navigate",
    "Sec-Fetch-Site": "none",
    "Sec-Fetch-User": "?1",
    "Upgrade-Insecure-Requests": "1",
    "User-Agent": "********",
}
post_headers = {
    "Accept": "*/*",
    "Accept-Language": "en,ja;q=0.9,zh;q=0.8,zh-CN;q=0.7",
    "Origin": "******",
    "Referer": "******",
    "Sec-Ch-Ua": '"Google Chrome";v="147", "Not.A/Brand";v="8", "Chromium";v="147"',
    "Sec-Ch-Ua-Mobile": "?0",
    "Sec-Ch-Ua-Platform": '"macOS"',
    "Sec-Fetch-Dest": "empty",
    "Sec-Fetch-Mode": "cors",
    "Sec-Fetch-Site": "same-origin",
    "User-Agent": "******",
}

def lambda_handler(event, context):
    url = "******"
    ip = "******"
    session = requests.Session()
    session.get(url, headers=get_headers, timeout=10)

    fake = Faker("ja_JP")

    name = fake.name()
    payload = {
        "name": (None, name),
        "full_name": (None, name),
        "phone": (None, fake.phone_number())
    }
    url_post = "******/?action=save_info"
    req = requests.Request("POST", url_post, headers=post_headers, files=payload)
    prepared = req.prepare()
    s = requests.Session()
    response = s.send(prepared)
    return {
        'statusCode': 200,
        'body': {
            "status": response.status_code,
            "data": payload,
            "content": response.text
        }
    }