#!/bin/bash

# List all hosted zone IDs
IDS=$(aws route53 list-hosted-zones --query 'HostedZones[*].Id' --output text)

# Loop through each hosted zone
for id in $IDS
do
    # Remove the leading '/hostedzone/' from the ID
    ZONE_ID=${id#/hostedzone/}

    # List and delete all record sets in the zone
    # Note: This excludes default record sets (NS and SOA)
    aws route53 list-resource-record-sets --hosted-zone-id $ZONE_ID --query 'ResourceRecordSets[?Type != `NS` && Type != `SOA`]' | jq -c '.[]' | while read -r resrecord; do
        aws route53 change-resource-record-sets --hosted-zone-id $ZONE_ID --change-batch "{\"Changes\":[{\"Action\":\"DELETE\",\"ResourceRecordSet\":$resrecord}]}"
    done

    # Delete the hosted zone
    aws route53 delete-hosted-zone --id $ZONE_ID
done

