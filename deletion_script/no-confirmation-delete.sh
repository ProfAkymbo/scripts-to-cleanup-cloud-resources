#!/bin/bash

# Set AWS CLI profile (optional)
#AWS_PROFILE="your-profile"

# Delete all EC2 instances
aws ec2 terminate-instances --instance-ids $(aws ec2 describe-instances --query 'Reservations[].Instances[].InstanceId' --output text)

# Delete all S3 buckets
for bucket in $(aws s3 ls | awk '{print $3}'); do
  aws s3 rb s3://$bucket --force
done
