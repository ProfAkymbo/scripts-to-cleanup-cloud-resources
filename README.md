# scripts-to-cleanup-cloud-resources
## Usage
- Save this script to a file (e.g., delete-resources.sh).
- Make the script executable: chmod +x delete-resources.sh.
- Run the script: ./delete-resources.sh.

## Delete all ec2 instances
 - Breakdown
1. aws ec2 describe-instances: Retrieves information about EC2 instances.
2. --query 'Reservations[].Instances[].InstanceId': Extracts instance IDs from the output.
3. --output text: Returns instance IDs as plain text.
4. aws ec2 terminate-instances --instance-ids: Terminates instances with specified IDs.

 ## Delete S3 buckets
- Breakdown
- 1. aws s3 ls: Lists S3 buckets.
- 2. awk '{print $3}': Extracts bucket names from the output.
- 3. aws s3 rb s3://$bucket --force: Deletes the bucket and its contents.

# modified script with confirmation prompts:
- How it works
- 1. read -p: Prompts the user to confirm deletion for each bucket.
- 2. -n 1 -r: Limits input to a single character and disables backslash escaping.
- 3. if [[ $REPLY =~ ^[Yy]$ ]]: Checks if the user input is 'y' or 'Y'.
- Benefits
- User Control: Allows users to selectively delete buckets.
- Prevents Accidents: Reduces the risk of accidental deletions.
