## 必要パッケージ
pip install requests faker -t .

## 圧縮
zip -r fishing_explosion.zip lambda_function.py faker requests urllib3 idna charset_normalizer certifi

## 作り
aws lambda create-function \
    --function-name fishing-explosion \
    --runtime python3.12 \
    --role arn:aws:iam::xxxxxxx:role/lambda-execution-role \
    --handler lambda_function.lambda_handler \
    --zip-file fileb://fishing_explosion.zip

## 更新
aws lambda update-function-code \
    --function-name fishing-explosion \
    --zip-file fileb://fishing_explosion.zip