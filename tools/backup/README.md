# Configure the Backup Policies
Backup or Data Protection got enabled for CosmosDB Accounts and Storage Accounts when they are created. However, 
the back up policies are to be set after creation of the resource. The policies.sh automates it for you. 
1. *CosmosDB Account:* The back up policies should reflect the following values.  
```
    Backup Interval: 8 hours.
    Backup Retention: 672 hours.
```
2. *Storage Account:* The data protection policies should reflect the following values. 
```
    PIT restore: Set, 28 days. 
    Soft Delete for blobs: Set, 29 days. 
    Versioning for blobs: Set.
    Blob change feed: Set.
```
__Why are the policies not set by default?__

Terraform doesn't have the feature to set up the back up policies, so we rely on az cli to achieve the same. 
The feature availability can be tracked [here](https://github.com/terraform-providers/terraform-provider-azurerm/issues/8507)
 for CosmosDB Account and [here](https://github.com/terraform-providers/terraform-provider-azurerm/issues/8268)
 for Service Account.

### Prerequisite
1. Ensure you are using az cli version higher than 2.17. [This](https://docs.microsoft.com/en-us/azure/cosmos-db/continuous-backup-restore-command-line#install) will help you upgrade. 
    For Bash, you can use
    ```curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash```.
    Restart your bash shell after the upgrade. 
2. Install cosmosdb preview extension. 
`az extension add --name cosmosdb-preview`
3. Login with appropriate service principal. 
`az login --service-principal -u $clientId -p $clientSecret --tenant $tenantId
` 
### When to run the script?
For **every resource group** in your deployment, run the update_backup_policies.sh script. After each run, verify the values are updated by visiting the portal. 