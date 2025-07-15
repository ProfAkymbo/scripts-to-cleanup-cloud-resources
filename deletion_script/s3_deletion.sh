#!/bin/bash

echo "Listing all S3 buckets in your account..."

# List all S3 buckets
BUCKET_NAMES=$(aws s3api list-buckets --query "Buckets[*].Name" --output text)

if [ -z "$BUCKET_NAMES" ]; then
  echo "No S3 buckets found."
else
  echo "Found buckets: $BUCKET_NAMES"
  echo "------------------------------------------------------------------"
  echo "WARNING: Deleting S3 buckets is irreversible and will delete all data."
  echo "To delete a bucket, it must be EMPTY first."
  echo "------------------------------------------------------------------"
  read -p "Do you want to proceed with listing and potentially deleting EMPTY buckets? (yes/no): " CONFIRMATION

  if [ "$CONFIRMATION" == "yes" ]; then
    for BUCKET in $BUCKET_NAMES; do
      echo "Checking bucket: $BUCKET"
      # Check if bucket is empty (list objects, if it returns nothing, it's empty)
      OBJECTS=$(aws s3api list-objects-v2 --bucket "$BUCKET" --query "Contents" --output text)

      if [ -z "$OBJECTS" ]; then
        echo "  Bucket '$BUCKET' is EMPTY. Deleting..."
        read -p "    Confirm deletion of empty bucket '$BUCKET'? (yes/no): " DELETE_CONFIRM
        if [ "$DELETE_CONFIRM" == "yes" ]; then
          aws s3api delete-bucket --bucket "$BUCKET"
          echo "    Bucket '$BUCKET' deleted."
        else
          echo "    Deletion of '$BUCKET' cancelled."
        fi
      else
        echo "  Bucket '$BUCKET' is NOT empty. Skipping deletion."
        # If you want to delete non-empty buckets, you'd need to add a command here
        # to delete all objects first:
        aws s3 rm s3://"$BUCKET" --recursive
        Then delete the bucket:
        aws s3api delete-bucket --bucket "$BUCKET"
        # BE EXTREMELY CAREFUL WITH THE ABOVE TWO LINES!
      fi
    done
  else
    echo "Operation cancelled."
  fi
fi
