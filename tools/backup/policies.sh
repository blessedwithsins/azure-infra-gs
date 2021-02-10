#!/bin/bash

# Backing up all Storage Accounts in the given Resource Group
function backupStorageAccounts() {
	local resourceGroup=$1

	STORAGE_ACCOUNTS=$(az resource list --resource-group ${resourceGroup} --resource-type "Microsoft.Storage/storageAccounts" --query '[].name' -o tsv)
	echo "Back up Configuring for SA"
	for storageAccount in $STORAGE_ACCOUNTS ;

		do
			echo "Setting backup policies for Storage Account: $storageAccount"
			az storage account blob-service-properties update \
			--resource-group $resourceGroup \
			--account-name "$storageAccount" \
			--enable-delete-retention true \
			--delete-retention-days 29 \
			--enable-versioning true \
			--enable-change-feed true \
			--enable-restore-policy true \
			--restore-days 28;
	done;
}

# Backing up all CosmosDB Accounts in the given Resource Group
function backupCosmosDBAccounts() {
	local resourceGroup=$1

	COSMOSDB_ACCOUNTS=$(az resource list --resource-group  ${resourceGroup} --resource-type "Microsoft.DocumentDb/databaseAccounts" --query '[].name' -o tsv)

	for cosmosDbAccount in $COSMOSDB_ACCOUNTS ;

		do
			echo "Setting backup policies for CosmosDB Account: $cosmosDbAccount"
			az cosmosdb update \
				-n  "$cosmosDbAccount" -g $resourceGroup\
				--backup-interval 8 \
				--backup-retention 672;
	done;
}

main() {
	local resourceGroup=$1
	local help=$2

	if [ "$help" == "true" ]; then
        echo "
			  Use -r options to specify Resource Group, for which back up is to be configured.
			  Use -h true option for help
			  "
        exit 0
    fi

	backupStorageAccounts $resourceGroup
	backupCosmosDBAccounts $resourceGroup
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