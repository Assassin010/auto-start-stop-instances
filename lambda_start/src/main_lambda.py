import boto3
region = 'us-east-1'
ec2 = boto3.client('ec2', region_name=region)
response = ec2.describe_instances(Filters=[
        {
            'Name': 'tag:Auto-Start-Stop',
            'Values': [
                'true',
            ]
        },
    ])

instances = []

for reservation in response["Reservations"]:
    for instance in reservation["Instances"]:
        instances.append(instance["InstanceId"])


def lambda_handler(event, context):
    ec2.start_instances(InstanceIds=instances)
    print('started instances: ' + str(instances))
