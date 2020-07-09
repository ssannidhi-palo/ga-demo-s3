#!/bin/bash
# Name: website.sh
# Author: Swati Sannidhi
# Description: This script is used to create/cleanup a S3 hosting website for the purpose of Github Actions training

usage() { 
	echo -e "\nUsage: $0 (create|cleanup) \n" 
	}

# Check number of arguments, display usage 
if [[  $# -ne 1 ]]; then 
    usage
    exit 1
fi 
 
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"

if [[ -f "policy_s3.json.bak" && -f "setenv.sh.bak" ]]; then
    rm -f policy_s3.json setenv.sh && mv policy_s3.json.bak policy_s3.json && mv setenv.sh.bak setenv.sh
fi

read -p "Enter a name (to $1 S3 hosting website): " USERNAME
read -p "Enter the Access Key ID: " ACCESS_KEY_ID
read -p "Enter the Secret Access Key: " SECRET_ACCESS_KEY

# Update policy file
sed -i.bak "s/username/$USERNAME/g" policy_s3.json

# Update env file
sed -i.bak "s/access-key-id/$ACCESS_KEY_ID/g; s/secret-access-key/$SECRET_ACCESS_KEY/g" setenv.sh

# Set AWS Envrironment
. ./setenv.sh

# Check if bucket exists
bucketstatus=$(aws s3api head-bucket --bucket training-demo-$USERNAME 2>&1)

case "$1" in
   "create")

        if [[ -z "$bucketstatus" ]]; then
                echo -e "\n A S3 hosting website already exists"
        else
            # Create a static website hosting in s3
            echo -e "\n Creating a S3 hosting website"
            aws s3 mb s3://training-demo-$USERNAME --region ap-southeast-1
            aws s3api wait bucket-exists --bucket training-demo-$USERNAME
            aws s3api put-object --bucket training-demo-$USERNAME --key index.html --body welcome.html --content-type "text/html" > /dev/null 2>&1
            aws s3 website s3://training-demo-$USERNAME --index-document index.html --error-document error.html
            aws s3api put-bucket-policy --bucket training-demo-$USERNAME --policy file://policy_s3.json
        fi
        echo -e "\n Your website Url: http://training-demo-$USERNAME.s3-website.ap-southeast-1.amazonaws.com"
    ;;

    "cleanup")

        if [[ -z "$bucketstatus" ]]; then
            echo -e "\n Cleaning up"
            aws s3 rb s3://training-demo-$USERNAME --force
            echo -e "\n Cleanup complete!"            
        else
            echo -e "\n No S3 hosting website (training-demo-$USERNAME) exists or you may not have permission to access"
        fi
    ;;
esac

if [[ -f "policy_s3.json.bak" && -f "setenv.sh.bak" ]]; then
    rm -f policy_s3.json setenv.sh && mv policy_s3.json.bak policy_s3.json && mv setenv.sh.bak setenv.sh
fi