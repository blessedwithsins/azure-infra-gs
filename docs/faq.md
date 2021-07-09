 # Frequently asked questions

This document answers some of the most common questions we have recieved from customers about OSDU on Azure. Please feel free to contribute with any additional information that may be valuable to others.

# Table of Contents
1. [Common Problems and Errors](#common-problems-and-errors)
1. [Infrastructure Provisioning Questions](#infrastructure-provisioning-questions)
1. [Infrastructure Provisioning Walkthroughs](#infrastructure-provisioning-walkthroughs)
1. [Service Questions](#service-questions)
1. [Infrastructure Upgrade Walkthroughs](#infrastructure-upgrade-walkthroughs)

# Common Problems and Errors

## 'Terraform Destroy' isn't properly cleaning up my environment

Sometimes when `terraform destroy` is done improperly (errors out, is cancelled before its finished etc) the terraform state becomes __locked__. In order to fix this you must navigate to your _terraform-remote-state-container_ and manually unlock the _tf_state_

## When I try to create the common resources I receive an error about the Key Vault already existing.

Key Vaults are created and by default are [Soft Delete](https://docs.microsoft.com/en-us/azure/key-vault/general/soft-delete-overview) enabled.  If a keyvault or secret in a keyvault were deleted an admin would have to manually `purge` the keyvault or secret.

## I can't change the names for my infrastructure deployment

When you are deploying via terraform, once you pick a name for the terraform script to use when naming Azure resources, you cannot change the naming convention so __choose carefully!!__

## I am gettting Insufficient privileges to complete the operation error while running central resource Terraform template

This is likely an issue with the `Application.ReadWrite.OwnedBy` permissions that is required by the service principal `osdu-mvp-[your unique here]-terraform`. Please verify that the service principal has been granted the permission and that the permission has recieved admin consent.


# Infrastructure Provisioning Questions

## What is the minimum permission required to Provision the Common Resources?

The common_prepare.sh script is a helper script that helps to perform the activities necessary to provision OSDU on Azure.  These activities can all be performed manually if desired.  Service Principals are created using the command `az ad sp create-for-rbac` which requires Owner permissions on a subscription to perform.
 
## Why does the Service Principal used by Terraform to create an OSDU Environment Stamp require Azure AD Graph API access levels of `Application.ReadWrite.OwnedBy`?

Terraform is used to provision an OSDU Environment Stamp a Service Principal is the identity used by Terraform to perform this action.  An OSDU Environment Stamp requires an AD Application used for Identity Management which is currently created by the Terraform Scripts.  In order for a Service Principal to be able to create Applications in AD, the permission of `Application.ReadWrite.OwnedBy` is required for the Azure AD Graph API.
 
## Why does the Service Principal used internally within an OSDU Environment Stamp require MS Graph API  access levels of `Directory.ReadAll`?

The OSDU Entitlement Service integrates with Azure AD.  The defined API spec for the service includes a Create method for which input criteria includes an email address.  This email address is looked up in Azure AD to confirm it exists and retrieve the Object Id of the user to be used as the source of identity which requires the permission of `Directory.ReadAll` for the MS Graph API.
 
## How can a Central IT organization provision out the Azure AD resources required on their own and how are they secured?

Any user with the appropriate permissions can create the Azure AD resources required which require Grant Admin Access to the API’s which is performed by an Azure AD Admin role.  These resources are then stored into a Key Vault to be used.  Azure Devops Pipelines can be run to perform the provisioning of an OSDU Environment Stamp using a Service Connection created on the Service Principal. Once the setup process of ADO and the Pipelines have been completed the Service Principal Secrets can be rotated and updated by Security in the Common Key Vault and access policies to the Common Key Vault can be limited to Security Teams only.
 
## Can an OSDU Environment Stamp be restricted to a single resource group or a set of pre-provisioned resource groups with Contributor Role Level Access to only the Resource Group?

An OSDU Environment Stamp creates Resource Group Names based on a convention pattern.  Data Partitions have a Resource Group boundary requirement for isolation security for Data Partitions.  After an OSDU Environment Stamp has been created Business Groups can be given RBAC access to perform desired actions in a Resource Group used by Diagnosis such as analyzing logs.  It is not common that the functionality of OSDU would require access to an OSDU Environment Stamp Resource Groups.
 
## What is the node ssh keypair generated by the common prepare script used for?

This key pair can be used to ssh into an AKS node if needed.

## What AAD Items are created by the common prepare script?

* osdu-mvp-xxx-terraform – A principal identity that can be used by Terraform for creating OSDU Resources
* osdu-mvp-xxx-principal – A principal identity that is fed to an OSDU Deployment to be used as the Root Level Identity for that OSDU Environment
* osdu-mvp-xxx-noaccess – A negative testing principal identity.
* osdu-mvp-xxx-application – An AD Application for future use.  (Not currently used yet.)

## What AAD Items are created by the central resource template?
* osdu-mvp-crxxx-xxxx-app – An AD application that defines the OSDU Environment created.

## What type of SSL certificate is used by default?
The current architecture by default uses a certificate manager by [Jet Stack]( https://github.com/jetstack/cert-manager) that automatically provisions certificates into the Application Gateway and currently is configured with 2 Issuers.  “Lets Encrypt Staging” and “Lets Encrypt Production”.  Future tasks will validate a process for a Bring Your Own Certificate.

## How to enable auto-delete of files from the file-staging-area blob container?
There is a lifecyle management policy applied on the file-staging-area container where in it can be decided to retain the data in it for a specified number of days.The default value for the retention days is 30.You can configure the number of days via variable "sa_retention_days" and enable this feature by setting the value of "storage_mgmt_policy_enabled" feature flag to true.

# Infrastructure Provisioning Walkthroughs

## Can someone show me how they set up OSDU on Azure?

OSDU on Azure is an open community and the best place to find the latest information is always to engage in the OSDU community. A couple of walkthrough videos do exist that might be of further assistance to get started.  Code, documentation and procedures are constantly evolving and the best place is to read the documentation, but a couple of walkthrough videos may be of assistance in getting started but can quickly become out of date.

__[Prepare Azure for OSDU](https://msosdu.azureedge.net/osdu-azure-prepare/osdu-azure-prepare.html)__
> Prepare the common resources necessary for installing an OSDU environment stamp.

- Prerequisites
- Cloning infrastructure
- Creating a Flux Manifest Repository
- Elastic Search Setup
- Configuring Key Access for Flux

__[Manual Installation](https://msosdu.azureedge.net/osdu-azure-manual/osdu-azure-manual.html)__
> Create an OSDU stamp manually using terraform.

- Install Infrastructure
- Setup DNS
- Upload Integration Test Data
- Deploy Helm Charts
- Register a Data Partition

__[Release Management](https://msosdu.azureedge.net/osdu-azure-release/index.html)__
> Upgrade a Manual Environment with a new Release

- Documentation (Release Management Overview)
- Upgrade Release M3 -> M4

__[Integration Testing](https://msosdu.azureedge.net/osdu-azure-testing/osdu-azure-testing.html)__
> Validate an environment using Integration Tests and REST API executions.

- Using REST API Samples
- Environment Variables
- Executing Integration Tests
- IDE Setup

__[Automation Pipelines](https://msosdu.azureedge.net/osdu-azure-pipelines/osdu-azure-pipelines.html)__
> Use Azure Devops Pipelines to build and deploy a full environment in sync with GitLab Master Branches

- Code Mirroring Pipelines
- Infrastructure Pipelines
- Setup DNS
- Upload Integration Test Data
- Setup Service Pipelines
- Register Data Partition

## How can I quickly ask questions when I get stuck.

There is a dedicated Slack Channel for asking questions in the community around installing OSDU on Azure where you can engage with the community and Micrososft Engineers.

[Slack #0_0_microsoft-infrastructure-questions](https://opensdu.slack.com/archives/C01JM5YLDV2)

# Service Questions

## Where can I see the current state of which services are supported on Azure?

Please see our changelog [here](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/CHANGELOG.md).

## When will [insert service name here] be onboarded with Azure?

You can see the status of the services we are onboarding under our service onboarding issue tracking label "Service Onboarding" [here](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues?label_name%5B%5D=Service+Onboarding).

## What level of security and control exist on OSDU API’s?

Security Layers of OSDU API’s currently exist for User Authentication and Authorization and application access is controlled by the Azure AD Application Client Id and Secret.  Future Roadmaps have discussed API management but has not been committed to.
 
## What mechanisms currently exist to Ingest Data can Azure Data Factory be leveraged for Data Ingestion?

Data Ingestion is currently under development and due to initial OSDU community restraints that exist the workflow integrated to the open source code base leverages Airflow for its workflow engine.

## How do I setup and manage users for Airflow?

Airflow Web authentication is now rbac enabled. To understand user roles, create new users and manage users please refer [here](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/docs/airflow-rbac-guide.md).

## How to create a User in Entitlements V2
Users in Entitlements V2 can be created and managed using this Rest Client [here](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/tools/rest/entitlement_manage.http)

Also refer this documentation [here](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/docs/osdu-entitlement-roles.md) to understand the heirarchy of groups and which permissions can be enabled by adding specific groups

# Infrastructure Upgrade Walkthroughs

This section will outline the process for upgrading infrastructure whenever we have a breaking change in our infrastructure templates.

# Known Issues and mitigation
1. Deploying the "App Gateway Solution" fails with "Enabling solution of type AzureAppGatewayAnalytics is not allowed" error.

      Error: Error creating/updating Log Analytics Solution "AzureAppGatewayAnalytics(osdu-mvp)" (Workspace "/subscriptions/xxx/resourceGroups/osdu-mvp/providers/Microsoft.OperationalInsights/workspaces/osdu-mvp" / Resource Group "osdu-mvp"): operationsmanagement.SolutionsClient#CreateOrUpdate: Failure sending request: StatusCode=400 -- Original Error: Code="InvalidOperationArgument" Message="Enabling solution of type AzureAppGatewayAnalytics is not allowed"

        on ../../../modules/providers/azure/log-analytics/main.tf line 36, in resource "azurerm_log_analytics_solution" "main":
        36: resource "azurerm_log_analytics_solution" "main" {


      Releasing state lock. This may take a few moments...
      ##[error]Script failed with error: Error: The process '/bin/bash' failed with exit code

    For release **0.8.0 and below** the cherry-pick the changes in the [MR](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/merge_requests/310) to fix the issue.
    
## Release 0.5.0 Upgrade (January 2021)
These steps outline the process of upgrading infrastructure to version 0.5.0.
1.	Disable any infrastructure pipelines.
1. Checkout [infra-azure-provisioning tag 0.4.2](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/tags/azure-0.4.2) and ensure that your environment TF plan looks good for all resources (do this manually).
1.	Ensure you were on the terraform version 12.29.
1.	Upgrade Terraform to 13.5 and do a tf init –upgrade, tf plan and tf apply on all templates 1 by 1 in order.  (Do this manually)
1.	Upgrade Terraform to 14.4 and do a tf init –upgrade, tf plan and tf apply on all templates 1 by 1 in order.  (Do this manually)
1.	Pull the master branch code latest.
1.	Unlock Resources in Central and Data Partition. This can be done in the Azure potal under each resource group's "Locks" tab. (Do this manually)
1.	Perform a tf init -upgrade, tf plan and tf apply on all templates 1 by 1 in order.  (Do this manually)
1.	Enable running the pipeline and execute them.
