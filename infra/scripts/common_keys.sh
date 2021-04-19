#!/usr/bin/env bash
#
#  Purpose: Show all the Keys in a Key Vault.
#  Usage:
#    common_keys.sh


###############################
## ARGUMENT INPUT            ##
###############################

if [ ! -z $1 ]; then COMMON_VAULT=$1; fi
if [ -z $COMMON_VAULT ]; then
  tput setaf 1; echo 'ERROR: COMMON_VAULT not provided' ; tput sgr0
  usage;
fi

###############################
## EXECUTE                   ##
###############################

tput setaf 2; echo 'Key Vault Dump...' ; tput sgr0
tput setaf 3; echo "------------------------------------" ; tput sgr0
for i in `az keyvault secret list --vault-name $COMMON_VAULT --query [].id -otsv`
do
   echo "${i##*/}=\"$(az keyvault secret show --id $i --query value -otsv)\""
done
