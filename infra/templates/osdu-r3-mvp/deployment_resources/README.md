# Azure OSDU MVC - Service Resources Configuration

The `osdu` - `service_resources` environment template is intended to provision to Azure resources for OSDU which are specifically used for the AKS cluster and configuration of the cluster.

__PreRequisites__

> These are typically performed by the `common_prepare.sh` scripts.


Requires the use of [direnv](https://direnv.net/) for environment variable management.

Set up your local environment variables

*Note: environment variables are automatically sourced by direnv*

Required Environment Variables (.envrc)
```bash
export ARM_TENANT_ID=""
export ARM_SUBSCRIPTION_ID=""

# Terraform-Principal
export ARM_CLIENT_ID=""
export ARM_CLIENT_SECRET=""

# Terraform State Storage Account Key
export TF_VAR_remote_state_account=""
export TF_VAR_remote_state_container=""
export ARM_ACCESS_KEY=""

# Instance Variables
export TF_VAR_resource_group_location="centralus"
```

__Configure__

Navigate to the `terraform.tfvars` terraform file. Here's a sample of the terraform.tfvars file for this template.

```HCL
prefix = "osdu-mvp"

resource_tags = {
  contact = "<your_name>"
}

# Storage Settings
storage_shares = [ "airflowdags" ]
storage_queues = [ "airflowlogqueue" ]
```

__Provision__

> Please run `helm repo update` prior to executing in case you have helm charts locally that need updates.

Execute the following commands to set up your terraform workspace.

```bash
# This configures terraform to leverage a remote backend that will help you and your
# team keep consistent state
terraform init -backend-config "storage_account_name=${TF_VAR_remote_state_account}" -backend-config "container_name=${TF_VAR_remote_state_container}"

# This command configures terraform to use a workspace unique to you. This allows you to work
# without stepping over your teammate's deployments
TF_WORKSPACE="sr-${UNIQUE}"
terraform workspace new $TF_WORKSPACE || terraform workspace select $TF_WORKSPACE
```

> Manually create a custom variable file to use for template configuration and edit as appropriate and desired.

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

## Testing

Please confirm that you've completed the `terraform apply` step before running the integration tests as we're validating the active terraform workspace.

Unit tests can be run using the following command:

```
go test -v $(go list ./... | grep "unit")
```

Integration tests can be run using the following command:

```
go test -v $(go list ./... | grep "integration")
```
