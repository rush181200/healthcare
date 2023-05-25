import boto3
import json

def lambda_handler(event, context):
    for record in event['Records']:
        if record['eventName'] == "MODIFY": 
            # Parse DynamoDB record
            username = record['dynamodb']['NewImage']['name']['S']
            email = record['dynamodb']['NewImage']['email']['S']
            new_hrate = record['dynamodb']['NewImage']['hrate']['M']['heart']['S']
            
            # Check heart rate data for abnormalities
            abnormal = True
            if int(float(new_hrate)) > 120 or int(float(new_hrate)) < 40:
                title = 'Abnormal Heart Rate Detected'
                title_body = 'Dear ' + username + ',\n\nWe are writing to inform you that our system has detected an abnormality in your heart rate. We understand that this may be concerning, but please don\'t panic. We are sending you this email so that you can take appropriate action to address the issue. Please contact your doctor for further evaluation.\n\nSincerely,\nHealthcare'
            else:
                title = 'Normal Heart Rate Detected'
                title_body = 'Dear ' + username + ',\n\nWe are pleased to inform you that our system has detected a normal heart rate during our monitoring period. This is good news and we hope it provides you with some peace of mind.\nOur system is designed to alert you if there are any abnormalities detected in your heart rate, but we also want to let you know when everything is within normal limits.\n\nSincerely,\nHealthcare'
    
            # Send email if abnormality detected
            if abnormal:
                ses = boto3.client('ses')
                subject = title
                body = title_body
                response = ses.send_email(
                    Source='rajmehta0602@gmail.com',
                    Destination={
                        'ToAddresses': [
                            email,
                        ],
                    },
                    Message={
                        'Subject': {
                            'Data': subject,
                        },
                        'Body': {
                            'Text': {
                                'Data': body,
                            },
                        },
                    },
                )
