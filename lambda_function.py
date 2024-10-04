import json
import requests
import os

def lambda_handler(event, context):
    subnet_id = os.environ['SUBNET_ID']
    payload = {
        "subnet_id": subnet_id,
        "name": "Aniruddha Gaikwad",
        "email": "aniruddha1536@gmail.com"
    }

    headers = {
        'X-Siemens-Auth': 'test'
    }

    # API Endpoint URL
    url = "https://bc1yy8dzsg.execute-api.eu-west-1.amazonaws.com/v1/data"

    try:
        response = requests.post(url, json=payload, headers=headers)
        response.raise_for_status()  # Ensure the request was successful

        return {
            'statusCode': response.status_code,
            'body': json.dumps(response.json())
        }
    except requests.exceptions.HTTPError as err:
        return {
            'statusCode': 500,
            'body': json.dumps({"error": str(err)})
        }