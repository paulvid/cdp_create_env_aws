#!/bin/bash 


 display_usage() { 
	echo "
Usage:
    $(basename "$0") <prefix> <template> [--help or -h]

Description:
    Launches as 3 nodes (1 master, 1 worker, 1 nifi master) CDP data hub workshop cluster.

Arguments:
    prefix:         prefix of your assets
    template:       name of the cluster template
    --help or -h:   displays this help"

}

# check whether user had supplied -h or --help . If yes display usage 
if [[ ( $1 == "--help") ||  $1 == "-h" ]] 
then 
    display_usage
    exit 0
fi 


# Check the numbers of arguments
if [  $# -lt 2 ] 
then 
    echo "Not enough arguments!"
    display_usage
    exit 1
fi 

if [  $# -gt 2 ] 
then 
    echo "Too many arguments!"
    display_usage
    exit 1
fi 

subnetId=$(cdp environments describe-environment --environment-name $1-cdp-env | jq -r .environment.network.subnetIds[0])

cdp datahub create-aws-cluster --cluster-name $1-dh-cluster \
    --environment-name $1-cdp-env \
    --cluster-template-name "$2" \
    --instance-groups "nodeCount=1,instanceGroupName=master,instanceGroupType=GATEWAY,instanceType=m5.2xlarge,rootVolumeSize=50,attachedVolumeConfiguration=[{volumeSize=100,volumeCount=1,volumeType=standard}],recoveryMode=MANUAL,volumeEncryption={enableEncryption=false}"  "nodeCount=3,instanceGroupName=worker,instanceGroupType=CORE,instanceType=m5.xlarge,rootVolumeSize=50,attachedVolumeConfiguration=[{volumeSize=100,volumeCount=1,volumeType=standard}],recoveryMode=MANUAL,volumeEncryption={enableEncryption=false}" "nodeCount=0,instanceGroupName=compute,instanceGroupType=CORE,instanceType=m5.2xlarge,rootVolumeSize=50,attachedVolumeConfiguration=[{volumeSize=100,volumeCount=12,volumeType=standard}],recoveryMode=MANUAL,volumeEncryption={enableEncryption=false}" \
    --subnet-id $subnetId \
    --image id="67415f81-ef63-4b44-700c-f65014a34202",catalogName="cloudbreak-default"  