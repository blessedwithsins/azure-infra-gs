# Monitoring Resources Configuration

This template provides an option of how dashboards can be deployed for OSDU.

__Prerequisites__

The monitoring resources require the central_resources, service_resources and data_partition resources to exist before-hand. Please follow directions [here](../README.md) to deploy them if not already done.

__Required environment variables__

Requires the use of [direnv](https://direnv.net/) for environment variable management.

Set up your local environment variables

Note: environment variables are automatically sourced by direnv

Required Environment Variables (.envrc)
```bash
export ARM_TENANT_ID=""
export ARM_SUBSCRIPTION_ID=""

## Terraform-Principal
export ARM_CLIENT_ID=""
export ARM_CLIENT_SECRET=""

## Terraform State Storage Account Key
export TF_VAR_remote_state_account=""
export TF_VAR_remote_state_container=""
export ARM_ACCESS_KEY=""
```

__Manually Provision__

Execute the following commands to set up your terraform workspace
```bash
# This configures terraform to leverage a remote backend that will help you and your
# team keep consistent state
terraform init -backend-config "storage_account_name=${TF_VAR_remote_state_account}" -backend-config "container_name=${TF_VAR_remote_state_container}"

# This command configures terraform to use a workspace unique to you. This allows you to work
# without stepping over your teammate's deployments
TF_WORKSPACE="mr-${UNIQUE}"
terraform workspace new $TF_WORKSPACE || terraform workspace select $TF_WORKSPACE
```


> Manually create a custom variable file to use for template configuration and edit as appropriate and desired.

In the custom.tfvars file manually configure your specific settings

- tenant_name -- This needs to be set and refers to the <tenant_name>.onmicrosoft.com from Azure AD
- dashboards -- Enable or disable dashboards as desired


```bash
cp terraform.tfvars custom.tfvars
```


Execute the following commands to orchestrate a deployment.


```bash
# See what terraform will try to deploy without actually deploying
terraform plan -var-file custom.tfvars

# Execute a deployment
terraform apply -var-file custom.tfvars
```

Optionally execute the following command to teardown your deployment and delete your resources.

```bash
# Destroy resources and tear down deployment. Only do this if you want to destroy your deployment.
terraform destroy
```
