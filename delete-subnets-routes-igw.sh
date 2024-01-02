#!/bin/bash

# Function to delete subnets, route tables, and internet gateways in a given region
delete_resources_in_region() {
    local region=$1
    echo "Working in region: $region"

    # Set AWS CLI to use the specified region
    export AWS_DEFAULT_REGION=$region

    # Delete all subnets
    for subnet in $(aws ec2 describe-subnets --query 'Subnets[*].SubnetId' --output text)
    do
        echo "Deleting subnet: $subnet"
        aws ec2 delete-subnet --subnet-id $subnet
    done

    # Delete all route tables (excluding main route tables)
    for rtb in $(aws ec2 describe-route-tables --query 'RouteTables[?Associations[?Main != `true`]].RouteTableId' --output text)
    do
        echo "Deleting route table: $rtb"
        aws ec2 delete-route-table --route-table-id $rtb
    done

    # Delete all internet gateways
    for igw in $(aws ec2 describe-internet-gateways --query 'InternetGateways[*].InternetGatewayId' --output text)
    do
        # Detach and delete each internet gateway
        for vpc in $(aws ec2 describe-internet-gateways --internet-gateway-id $igw --query 'InternetGateways[*].Attachments[*].VpcId' --output text)
        do
            echo "Detaching internet gateway: $igw from VPC: $vpc"
            aws ec2 detach-internet-gateway --internet-gateway-id $igw --vpc-id $vpc
        done
        echo "Deleting internet gateway: $igw"
        aws ec2 delete-internet-gateway --internet-gateway-id $igw
    done
}

# Get list of all AWS regions
regions=$(aws ec2 describe-regions --query 'Regions[*].RegionName' --output text)

# Iterate over each region
for region in $regions
do
    delete_resources_in_region $region
done

