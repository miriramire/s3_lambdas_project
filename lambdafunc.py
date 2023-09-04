import json
import boto3

from datetime import datetime

s3_client = boto3.client('s3')

def calculate_yearly_salary(salary):
    try:
        yearly_salary = float(salary) * 12  # Assuming salary is given as monthly
        return yearly_salary
    except ValueError:
        return None  # Invalid input, return None or handle the error accordingly

def lambda_handler(event, context):
    # Getting Bucket name and key
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']
    
    # getting content as STR
    response = s3_client.get_object(Bucket=bucket, Key=key)
    content = response['Body'].read().decode('utf-8')
    
    # Retrieve the JSON data from the Lambda event
    input_json = json.loads(content)
    
    for data in input_json:
         # Data Manipulation
        data['year_salary'] = calculate_yearly_salary(data.get('salary'))

    # Convert the modified JSON data back to a string
    modified_json_str = json.dumps(input_json)

    # Specify the S3 bucket and key where you want to save the modified JSON
    timestamp = datetime.now().strftime('%Y-%m-%d_%H-%M-%S')
    new_key = f'output/modified_data{timestamp}.json'

    # Upload the modified JSON to S3
    s3_client.put_object(Bucket=bucket, Key=new_key, Body=modified_json_str)

    return {
        'statusCode': 200,
        'body': json.dumps('JSON modification and upload to S3 complete')
    }