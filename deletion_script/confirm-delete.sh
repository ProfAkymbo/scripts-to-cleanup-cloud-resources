#!/bin/bash

for instance_id in $(aws ec2 describe-instances --query 'Reservations[].Instances[].InstanceId' --output text); do
  read -p "Terminate instance $instance_id? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    aws ec2 terminate-instances --instance-ids $instance_id
  fi
done

# script with confirmation prompts to delete all buckets and the contents:
for bucket in $(aws s3 ls | awk '{print $3}'); do
  read -p "Delete bucket $bucket and its contents? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    if aws s3 rb s3://$bucket --force; then
      echo "Bucket $bucket deleted successfully"
    else
      echo "Error deleting bucket $bucket"
    fi
  else
    echo "Skipping bucket $bucket"
  fi
done
