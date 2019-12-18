#!/bin/bash 
set -o nounset

display_usage() { 
    echo "
Usage:
    $(basename "$0") [--help or -h] <prefix> <credential> <region> <key>

Description:
    Launches a CDP environment

Arguments:
    prefix:         prefix for your assets
    credentials:    CDP credential name
    region:         region for your env
    key:            name of the AWS key to re-use
    --help or -h:   displays this help"

}

# check whether user had supplied -h or --help . If yes display usage 
if [[ ( ${1:-x} == "--help") ||  ${1:-x} == "-h" ]] 
then 
    display_usage
    exit 0
fi 


# Check the numbers of arguments
if [  $# -lt 4 ] 
then 
    echo "Not enough arguments!"
    display_usage
    exit 1
fi 

if [  $# -gt 4 ] 
then 
    echo "Too many arguments!"
    display_usage
    exit 1
fi 

prefix=$1
credential=$2
region=$3
key=$4

export AWS_ACCOUNT_ID=$(aws sts get-caller-identity | jq .Account -r)

cdp environments create-aws-environment --environment-name ${prefix}-cdp-env \
    --credential-name ${credential} \
    --region ${region} \
    --security-access cidr="0.0.0.0/0"  \
    --authentication publicKeyId="${key}" \
    --log-storage storageLocationBase="${prefix}-cdp-bucket",instanceProfile="arn:aws:iam::$AWS_ACCOUNT_ID:instance-profile/${prefix}-idbroker-role" \
    --network-cidr "10.0.0.0/16" \
    --s3-guard-table-name ${prefix}-cdp-table
