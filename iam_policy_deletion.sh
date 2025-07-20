#!/bin/bash

# This deletes all custom policies in the AWS account
for policy_arn in $(aws iam list-policies --scope Local --query 'Policies[].Arn' --output text); do
  policy_name=$(aws iam list-policies --query "Policies[?Arn=='$policy_arn'].PolicyName" --output text)

  # Detach from roles
  for role in $(aws iam list-entities-for-policy --policy-arn $policy_arn --query 'PolicyRoles[].RoleName' --output text); do
    aws iam detach-role-policy --role-name $role --policy-arn $policy_arn
  done

  # Detach from users
  for user in $(aws iam list-entities-for-policy --policy-arn $policy_arn --query 'PolicyUsers[].UserName' --output text); do
    aws iam detach-user-policy --user-name $user --policy-arn $policy_arn
  done

  # Detach from groups
  for group in $(aws iam list-entities-for-policy --policy-arn $policy_arn --query 'PolicyGroups[].GroupName' --output text); do
    aws iam detach-group-policy --group-name $group --policy-arn $policy_arn
  done

  # Delete policy
  aws iam delete-policy --policy-arn $policy_arn
done
