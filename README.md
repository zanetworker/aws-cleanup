# AWS Resource Cleanup Scripts

This repository contains a collection of shell scripts to help clean up AWS resources in multiple regions.

## Usage

To use these scripts, you need to have the AWS CLI installed and configured with your AWS credentials.

1. Clone this repository:

   ```shell
   git clone https://github.com/zanetworker/aws-cleanup.git
   ```

2. Change into the repository directory:

   ```shell
   cd aws-cleanup
   ```

3. Make the shell scripts executable:

   ```shell
   chmod +x delete-route-tables.sh
   chmod +x delete-subnets-routes-igw.sh
   chmod +x delete-hosted-zones.sh
   ```

4. Run the desired script(s) to delete the corresponding AWS resources:

   - `delete-route-tables.sh`: Deletes custom route tables in all AWS regions except for the main route tables.
   - `delete-subnets-routes-igw.sh`: Deletes subnets, route tables (excluding main route tables), and internet gateways in all AWS regions.
   - `delete-hosted-zones.sh`: Deletes all hosted zones and their associated record sets in AWS Route 53.

   ```shell
   ./delete-route-tables.sh
   ./delete-subnets-routes-igw.sh
   ./delete-hosted-zones.sh
   ```

**Note:** These scripts will delete resources. Please use with caution and review the code before running them.

## License

This project is licensed under the [MIT License](LICENSE).