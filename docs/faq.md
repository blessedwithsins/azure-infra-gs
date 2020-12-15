# Frequently asked questions

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
 
## What level of security and control exist on OSDU API’s?

Security Layers of OSDU API’s currently exist for User Authentication and Authorization and application access is controlled by the Azure AD Application Client Id and Secret.  Future Roadmaps have discussed API management but has not been committed to.
 
## What mechanisms currently exist to Ingest Data can Azure Data Factory be leveraged for Data Ingestion?

Data Ingestion is currently under development and due to initial OSDU community restraints that exist the workflow integrated to the open source code base leverages Airflow for its workflow engine.
 