#!/bin/bash 
set -o nounset

display_usage() { 
    echo "
Usage:
    $(basename "$0") [--help or -h] <prefix>

Description:
    Purges roles and policies for minimal env setup

Arguments:
    prefix:   prefix for your buckets and roles
    --help or -h:   displays this help"

}

# check whether user had supplied -h or --help . If yes display usage 
if [[ ( ${1:-x} == "--help") ||  ${1:-x} == "-h" ]] 
then 
    display_usage
    exit 0
fi 


# Check the numbers of arguments
if [  $# -lt 1 ] 
then 
    echo "Not enough arguments!"
    display_usage
    exit 1
fi 

if [  $# -gt 1 ] 
then 
    echo "Too many arguments!"
    display_usage
    exit 1
fi 

prefix=$1

sleep_duration=3

export AWS_ACCOUNT_ID=$(aws sts get-caller-identity | jq .Account -r)

echo "Deleting Roles"
aws iam remove-role-from-instance-profile --instance-profile-name ${prefix}-idbroker-role --role-name ${prefix}-idbroker-role

aws iam delete-instance-profile --instance-profile-name ${prefix}-idbroker-role 
aws iam detach-role-policy --role-name ${prefix}-idbroker-role --policy-arn arn:aws:iam::$AWS_ACCOUNT_ID:policy/${prefix}-idbroker-assume-role-policy
aws iam delete-role --role-name ${prefix}-idbroker-role

aws iam detach-role-policy --role-name ${prefix}-datalake-admin-role --policy-arn arn:aws:iam::$AWS_ACCOUNT_ID:policy/${prefix}-bucket-policy-s3access
aws iam detach-role-policy --role-name ${prefix}-datalake-admin-role --policy-arn arn:aws:iam::$AWS_ACCOUNT_ID:policy/${prefix}-dynamodb-policy
aws iam detach-role-policy --role-name ${prefix}-datalake-admin-role --policy-arn arn:aws:iam::$AWS_ACCOUNT_ID:policy/${prefix}-datalake-admin-policy-s3access
aws iam delete-role --role-name ${prefix}-datalake-admin-role 

aws iam detach-role-policy --role-name ${prefix}-log-role --policy-arn arn:aws:iam::$AWS_ACCOUNT_ID:policy/${prefix}-log-policy-s3access
aws iam detach-role-policy --role-name ${prefix}-log-role --policy-arn arn:aws:iam::$AWS_ACCOUNT_ID:policy/${prefix}-bucket-policy-s3access
aws iam detach-role-policy --role-name ${prefix}-log-role --policy-arn arn:aws:iam::$AWS_ACCOUNT_ID:policy/${prefix}-ranger-audit-policy-s3access
aws iam detach-role-policy --role-name ${prefix}-log-role --policy-arn arn:aws:iam::$AWS_ACCOUNT_ID:policy/${prefix}-dynamodb-policy
aws iam delete-role --role-name ${prefix}-log-role 

echo "Deleting Policies"
aws iam delete-policy --policy-arn arn:aws:iam::$AWS_ACCOUNT_ID:policy/${prefix}-idbroker-assume-role-policy
aws iam delete-policy --policy-arn arn:aws:iam::$AWS_ACCOUNT_ID:policy/${prefix}-log-policy-s3access
aws iam delete-policy --policy-arn arn:aws:iam::$AWS_ACCOUNT_ID:policy/${prefix}-ranger-audit-policy-s3access 
aws iam delete-policy --policy-arn arn:aws:iam::$AWS_ACCOUNT_ID:policy/${prefix}-datalake-admin-policy-s3access 
aws iam delete-policy --policy-arn arn:aws:iam::$AWS_ACCOUNT_ID:policy/${prefix}-bucket-policy-s3access
aws iam delete-policy --policy-arn arn:aws:iam::$AWS_ACCOUNT_ID:policy/${prefix}-dynamodb-policy

echo "Roles and Policies purged!"
