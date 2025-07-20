#!/bin/bash
for role in $(aws iam list-roles --query 'Roles[].RoleName' --output text); do
  read -p "Delete role $role? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    if aws iam delete-role --role-name $role; then
      echo "Role $role deleted successfully"
    else
      echo "Error deleting role $role (might be in use)"
    fi
  else
    echo "Skipping role $role"
  fi
done
