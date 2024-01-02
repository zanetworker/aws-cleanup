#!/bin/bash

# Function to delete custom route tables in a given region
delete_custom_route_tables_in_region() {
    local region=$1
    echo "Working in region: $region"

    # Set AWS CLI to use the specified region
    export AWS_DEFAULT_REGION=$region

    # Get all route tables
    route_tables=$(aws ec2 describe-route-tables --query 'RouteTables[*].RouteTableId' --output text)

    # Iterate over each route table
    for rtb in $route_tables
    do
        # Check if the route table is a main route table
        is_main=$(aws ec2 describe-route-tables --route-table-id $rtb --query 'RouteTables[*].Associations[?Main==`true`]' --output text)

        # If not a main route table, delete it
        if [ -z "$is_main" ]; then
            echo "Deleting custom route table: $rtb"
            aws ec2 delete-route-table --route-table-id $rtb
        else
            echo "Skipping main route table: $rtb"
        fi
    done
}

# Get list of all AWS regions
regions=$(aws ec2 describe-regions --query 'Regions[*].RegionName' --output text)

# Iterate over each region
for region in $regions
do
    delete_custom_route_tables_in_region $region
done

