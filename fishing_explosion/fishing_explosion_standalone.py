# VPNを掛けて、ローカル実行スクリプト
import requests
import time
import re
from faker import Faker
import json
import random

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
    "User-Agent": "xxxxx",
}
post_headers = {
    "Accept": "*/*",
    "Accept-Language": "en,ja;q=0.9,zh;q=0.8,zh-CN;q=0.7",
    "Origin": "xxxx",
    "Referer": "xxxx",
    "Sec-Ch-Ua": '"Google Chrome";v="147", "Not.A/Brand";v="8", "Chromium";v="147"',
    "Sec-Ch-Ua-Mobile": "?0",
    "Sec-Ch-Ua-Platform": '"macOS"',
    "Sec-Fetch-Dest": "empty",
    "Sec-Fetch-Mode": "cors",
    "Sec-Fetch-Site": "same-origin",
    "User-Agent": "xxxx",
}

name_list = [
    "xxxxx何も",
]

def generate_random_user():
    full_name = f"{random.choice(name_list)}"
    return full_name

phone_prefixes = ["090", "080", "070"]

def generate_random_phone():
    phone_list = [
        f"{random.choice(phone_prefixes)}-{random.randint(1000, 9999)}-{random.randint(1000, 9999)}",
        f"{random.choice(phone_prefixes)}{random.randint(1000, 9999)}{random.randint(1000, 9999)}",
        "何も",
        "", None
    ]
    phone = random.choice(phone_list)
    return phone

def get_payload():
    name = random.choice([generate_random_user(), str(random.randint(-9999999, 999999999)/random.randint(1, 999999999)*random.randint(1, 999999999))])
    phone = random.choice([generate_random_phone(), str(random.randint(-9999999, 999999999)/random.randint(1, 999999999)*random.randint(1, 999999999))])
    payload = {
        "name": (None, name),
        "full_name": (None, name),
        "phone": (None, phone)
    }
    return payload


def lambda_handler():
    url = "xxxx"
    ip = ""
    session = requests.Session()
    session.get(url, headers=get_headers, timeout=10)

    payload = get_payload()
    url_post = "xxxx"
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

while True:
    print(lambda_handler())
    time.sleep(random.randint(1, 10))