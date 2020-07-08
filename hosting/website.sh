#!/bin/bash

if [[ -f "policy_s3.json.bak" && -f "setenv.sh.bak" ]]; then
rm -f policy_s3.json setenv.sh && mv policy_s3.json.bak policy_s3.json && mv setenv.sh.bak setenv.sh
fi

read -p "Enter a name (A S3 hosting website will be created for you): " USERNAME
read -p "Enter the Access Key ID: " ACCESS_KEY_ID
read -p "Enter the Secret Access Key: " SECRET_ACCESS_KEY

# Update env file
sed -i.bak "s/access-key-id/$ACCESS_KEY_ID/g; s/secret-access-key/$SECRET_ACCESS_KEY/g" setenv.sh

# Set AWS Envrironment
. ./setenv.sh

# Update policy file
sed -i.bak "s/username/$USERNAME/g" policy_s3.json

# Check if bucket exists
bucketstatus=$(aws s3api head-bucket --bucket training-palo-$USERNAME 2>&1)

if [[ -z "$bucketstatus" ]]; then
        echo -e "\n A S3 hosting website already exists"
else
    # Create a static website hosting in s3
    echo -e "\n Creating a S3 hosting website"
    aws s3 mb s3://training-palo-$USERNAME --region ap-southeast-1 > /dev/null 2>&1
    aws s3api wait bucket-exists --bucket training-palo-$USERNAME
    aws s3api put-object --bucket training-palo-$USERNAME --key index.html --body welcome.html --content-type "text/html" > /dev/null 2>&1
    aws s3 website s3://training-palo-$USERNAME --index-document index.html --error-document error.html
    aws s3api put-bucket-policy --bucket training-palo-$USERNAME --policy file://policy_s3.json
fi
echo -e "\n Your website Url: http://training-palo-$USERNAME.s3-website.ap-southeast-1.amazonaws.com"

if [[ -f "policy_s3.json.bak" && -f "setenv.sh.bak" ]]; then
rm -f policy_s3.json setenv.sh && mv policy_s3.json.bak policy_s3.json && mv setenv.sh.bak setenv.sh
fi