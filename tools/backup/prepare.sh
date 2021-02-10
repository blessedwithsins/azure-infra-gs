#!/bin/bash

# Utility fuction to prepare the Azure CLI
function prepareAzureCli() {
	local azUser=$1
	local azSecret=$2
	local azTenant=$3
	echo "Updating az cli."
	curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

	echo "Adding CosmosDB Account update extension."
	az extension add --name cosmosdb-preview

	echo "azure cli login."
	az login --service-principal -u $azUser -p $azSecret --tenant $azTenant
}

main() {
	local azUser=$1
	local azSecret=$2
	local azTenant=$3
	local help=$4

	if [ "$help" == "true" ]; then
        echo "
			  Use -u ClientId that has to be used for az login.
			  Use -s ClientSecret that has to be used for az login.
			  Use -t Tenat that has to be used for az login.
			  Use -h true option for help
			  "
        exit 0
    fi

    prepareAzureCli $azUser $azSecret $azTenant
}

# Handling Inputs
azUser=""
azSecret=""
azTenant=""
help="false"
while getopts ":u:p:t::h::" opt; do
    case $opt in
		u)
			azUser=$OPTARG
			;;
		p)
			azSecret=$OPTARG
			;;
		t)
			azTenant=$OPTARG
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

main "$azUser" "$azSecret" "$azTenant" "$help"