#!/bin/bash

# Config values for Service Account Data Protection Policies.
ENABLE_DELETE_RETENTION="true"
DELETE_RETENTION_DAYS=29
ENABLE_VERSIONING="true"
ENABLE_CHANGE_FEED="true"
ENABLE_RESTORE_POLICY="true"
RESTORE_DAYS=28

# Config values for CosmosDB Account Backup Policies.
BACKUP_INTERVAL_IN_MINUTES=480
BACKUP_RETENTION_IN_HOURS=672

# Literals
RESOURCETYPE_STORAGE_ACCOUNT="Microsoft.Storage/storageAccounts"
RESOURCETYPE_COSMOSDB_ACCOUNT="Microsoft.DocumentDb/databaseAccounts"
QUERY_FOR_NAME='[].name'

# arguments (message)
function log() {
  echo >&2 "[update_backup_policies.sh] $1"
}

function configureDataProtectionPoliciesForStorageAccounts() {
    log "function:start: ${FUNCNAME}"
	log "Setting Data Protection policies for all Storage Accounts in the Resource Group: ${resourceGroup}."
	log "following properties would be updated:"
	log "DELETE_RETENTION_DAYS: ${DELETE_RETENTION_DAYS}"
	log "RESTORE_DAYS: ${RESTORE_DAYS}"
	
	local resourceGroup=$1
	
	storageAccounts=$(az resource list \
	                    --resource-group "${resourceGroup}" \
	                    --resource-type "${RESOURCETYPE_STORAGE_ACCOUNT}" \
	                    --query "${QUERY_FOR_NAME}" \
	                    --output tsv)

	for storageAccount in $storageAccounts ;
		do
			storageAccount=$(echo "${storageAccount}" | sed -r 's/\/r//g')
			log "Setting backup policies for Storage Account: ${storageAccount}."
			az storage account blob-service-properties update \
        --resource-group "${resourceGroup}" \
        --account-name "${storageAccount}" \
        --enable-delete-retention "${ENABLE_DELETE_RETENTION}" \
        --delete-retention-days "${DELETE_RETENTION_DAYS}" \
        --enable-versioning "${ENABLE_VERSIONING}" \
        --enable-change-feed "${ENABLE_CHANGE_FEED}" \
        --enable-restore-policy "${ENABLE_RESTORE_POLICY}" \
        --restore-days "${RESTORE_DAYS}";
	  done;
	log "function:end: ${FUNCNAME}"
}

function configureBackupPoliciesForCosmosDbAccounts() {
	log "function:start: ${FUNCNAME}"
	log "Setting backup policies all CosmosDB Accounts in Resource Group: ${resourceGroup}."
	log "following properties would be updated:"
	log "BACKUP_INTERVAL_IN_MINUTES: ${BACKUP_INTERVAL_IN_MINUTES}"
	log "BACKUP_RETENTION_IN_HOURS: ${BACKUP_RETENTION_IN_HOURS}"	

	local resourceGroup=$1
	
	cosmosdbAccounts=$(az resource list \
	                     --resource-group "${resourceGroup}" \
	                     --resource-type "${RESOURCETYPE_COSMOSDB_ACCOUNT}" \
	                     --query "${QUERY_FOR_NAME}" \
	                     --output tsv)
	
	for cosmosDbAccount in $cosmosdbAccounts ;
		do
		  cosmosDbAccount=$(echo "${cosmosDbAccount}" | sed -r 's/\/r//g')
			log "Setting backup policies for CosmosDB Account: ${cosmosDbAccount}."
			az cosmosdb update \
				--name "${cosmosDbAccount}"\
				--resource-group "${resourceGroup}"\
				--backup-interval "${BACKUP_INTERVAL_IN_MINUTES}" \
				--backup-retention "${BACKUP_RETENTION_IN_HOURS}" ;
	  done;
	log "function:end: ${FUNCNAME}"  
}

main() {
	log "function:start: ${FUNCNAME}"
	local resourceGroup=$1
	local help=$2

	if [ "$help" == "true" ]; then
        echo "
			  Use -r options to specify Resource Group, for which back up is to be configured.
			  Use -h true option for help
			  "
        exit 0
    fi

	configureDataProtectionPoliciesForStorageAccounts "${resourceGroup}"
	configureBackupPoliciesForCosmosDbAccounts "${resourceGroup}"
	log "function:end: ${FUNCNAME}"
}

# Input Management
resourceGroup=""
help="false"
while getopts ":r::h::" opt; do
    case $opt in
        r)
          resourceGroup=$OPTARG
          ;;
        h)
          help="true"
          ;;
		    \?)
          echo "Invalid option: -$OPTARG"
          echo "Use -h true option for help"
          exit 1
          ;;
        :)
          echo "Option -$OPTARG requires an argument."
          echo "Use -h true option for help"
          exit 1
          ;;
    esac
done

main "$resourceGroup" "$help"