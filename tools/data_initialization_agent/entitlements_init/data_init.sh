#!/bin/bash

currentStatus=""
currentMessage=""

OSDU_URI=${OSDU_HOST}

if [[ ${OSDU_HOST} != "https://"* ]] || [[ ${OSDU_HOST} != "http://"* ]]; then
  OSDU_URI="https://${OSDU_HOST}"
fi

echo "Trying to Fetch Access Token"
ACCESS_TOKEN=$(sh ./get_access_token.sh)
if [[ "$ACCESS_TOKEN" == "TOKEN_FETCH_FAILURE" ]]; then
  currentStatus="failure"
  currentMessage="${currentMessage}. Failure fetching Access Token. "
else
  echo "Access Token fetched successfully."

  IFS=',' read -r -a partitions_array <<< ${PARTITIONS}
  
  partition_count=0
  partition_initialized_count=0
  partition_user_initialized_count=0
  partition_admin_initialized_count=0
  
  for index in "${!partitions_array[@]}"
  do
    partition_count=$(expr $partition_count + 1)
    echo "Intitializing Entitlements for Partition: ${partitions_array[index]}"
  
    OSDU_ENTITLEMENTS_INIT_URI=${OSDU_URI}/api/entitlements/v2/tenant-provisioning
    echo "Entitlements Partition Initialization Endpoint: ${OSDU_ENTITLEMENTS_INIT_URI}"
  
    i=0
    partition_initialized=false
    while [[ $i -lt 3 ]]; do
      i=$(expr $i + 1)
      
      init_response=$(curl -s -w " Http_Status_Code:%{http_code} " \
        -X POST \
        -H 'Content-Type: application/json' \
        -H "Authorization: Bearer $ACCESS_TOKEN" \
        -H "data-partition-id: ${partitions_array[index]}" \
        $OSDU_ENTITLEMENTS_INIT_URI)
    
      echo "Init Reponse: $init_response"
  
      if [ -z "$init_response" -a "$init_response"==" " ]; then
        echo "Initialization Failed, Empty Reponse. Iteration $i."
        continue
      fi
  
      # Status code check. succeed only if 2xx
      # quit for partition if 404 or 400.
      # 401 or 403, then retry after getting access token.
      # else sleep for 1min and retry
      if [[ ${init_response} != *"Http_Status_Code:2"* ]];then
        if [[ ${init_response} == *"Http_Status_Code:400"* ]] || [[ ${init_response} == *"Http_Status_Code:404"* ]];then
          currentStatus="failure"
          currentMessage="${currentMessage}. Entitlements Init for partition ${partitions_array[index]} failed with response $init_response. "
          echo "Entitlements Init for partition ${partitions_array[index]} failed with response $init_response"
          break
        fi
  
        echo "Sleeping for 1min."
        sleep 1m
  
        if [[ ${init_response} == *"Http_Status_Code:401"* ]] || [[ ${init_response} == *"Http_Status_Code:403"* ]];then
          echo "Trying to Re-Fetch Access Token"
          ACCESS_TOKEN=$(sh ./get_access_token.sh)
          if [[ "$ACCESS_TOKEN" == "TOKEN_FETCH_FAILURE" ]]; then
            currentStatus="failure"
            currentMessage="${currentMessage}. Failure re-fetching Access Token. "
            echo "Failure re-fetching Access Token"
            break
          fi
          echo "Access Token re-fetched successfully."
        fi
  
        continue
      else
        currentMessage="${currentMessage}. Entitlements for Partition ${partitions_array[index]} Initialized successfully. "
        echo "Entitlements for Partition ${partitions_array[index]} Initialized successfully."
        partition_initialized_count=$(expr $partition_initialized_count + 1)
        partition_initialized=true
  
        break
      fi
    done

    if [[ $i -ge 3 ]]; then
      currentStatus="failure"
      currentMessage="${currentMessage}. Entitlements Init: Max Number of retries reached. "
    fi

    if [ "$partition_initialized" != true ] ; then
      currentStatus="failure"
      currentMessage="${currentMessage}. Skipping Adding User as an Admin as Entitlements Init has failed. "
      echo "Skipping Adding User as an Admin as Entitlements Init has failed."
      continue
    fi

    echo "Creating User Entitlements for Partition: ${partitions_array[index]}"  
    
    OSDU_ENTITLEMENTS_CREATE_USER_URI=${OSDU_URI}/api/entitlements/v2/groups/users@${partitions_array[index]}.$SERVICE_DOMAIN/members
    echo "Entitlements Partition Create User Endpoint: ${OSDU_ENTITLEMENTS_CREATE_USER_URI}"
  
    i=0
    while [[ $i -lt 3 ]]; do
      i=$(expr $i + 1)

      init_response=$(curl -s -w " Http_Status_Code:%{http_code} " \
        -X POST \
        -H 'Content-Type: application/json' \
        -H "Authorization: Bearer $ACCESS_TOKEN" \
        -H "data-partition-id: ${partitions_array[index]}" \
        -d "{\"email\":\"$ADMIN_ID\", \"role\": \"MEMBER\"}" \
        $OSDU_ENTITLEMENTS_CREATE_USER_URI)
      
      echo "Init Reponse: $init_response"
  
      if [ -z "$init_response" -a "$init_response"==" " ]; then
        echo "Create User Failed, Empty Reponse. Iteration $i."
        continue
      fi
  
      # Status code check. succeed only if 2xx
      # quit for partition if 404 or 400.
      # 401 or 403, then retry after getting access token.
      # else sleep for 1min and retry
      if [[ ${init_response} != *"Http_Status_Code:2"* ]] && [[ ${init_response} != *"Http_Status_Code:409"* ]];then
        if [[ ${init_response} == *"Http_Status_Code:400"* ]] || [[ ${init_response} == *"Http_Status_Code:404"* ]];then
          currentStatus="failure"
          currentMessage="${currentMessage}. Create User for partition ${partitions_array[index]} failed with response $init_response. "
          echo "Create User for partition ${partitions_array[index]} failed with response $init_response"
          break
        fi
  
        echo "Sleeping for 1min."
        sleep 1m
  
        if [[ ${init_response} == *"Http_Status_Code:401"* ]] || [[ ${init_response} == *"Http_Status_Code:403"* ]];then
          echo "Trying to Re-Fetch Access Token"
          ACCESS_TOKEN=$(sh ./get_access_token.sh)
          if [[ "$ACCESS_TOKEN" == "TOKEN_FETCH_FAILURE" ]]; then
            currentStatus="failure"
            currentMessage="${currentMessage}. Failure re-fetching Access Token. "
            echo "Failure re-fetching Access Token"
            break
          fi
          echo "Access Token re-fetched successfully."
        fi
  
        continue
      else
        if [[ ${init_response} == *"Http_Status_Code:409"* ]];then
          currentMessage="${currentMessage}. HTTP Status Code: 409 -> Admin User ${partitions_array[index]} Already Exists. "
          echo "HTTP Status Code: 409 -> User ${partitions_array[index]} Already Exists."
        fi
        currentMessage="${currentMessage}. User for Partition ${partitions_array[index]} Initialized successfully. "
        echo "User for Partition ${partitions_array[index]} Initialized successfully."
        partition_user_initialized_count=$(expr $partition_user_initialized_count + 1)
  
        break
      fi
    done

    if [[ $i -ge 3 ]]; then
      currentStatus="failure"
      currentMessage="${currentMessage}. Creating User: Max Number of retries reached. "
    fi

    echo "Adding Admin User Entitlements for Partition: ${partitions_array[index]}"  
    
    OSDU_ENTITLEMENTS_ADD_OPS_URI=${OSDU_URI}/api/entitlements/v2/groups/users.datalake.ops@${partitions_array[index]}.$SERVICE_DOMAIN/members
    echo "Entitlements Partition Add Ops Endpoint: ${OSDU_ENTITLEMENTS_ADD_OPS_URI}"
  
    i=0
    while [[ $i -lt 3 ]]; do
      i=$(expr $i + 1)

      init_response=$(curl -s -w " Http_Status_Code:%{http_code} " \
        -X POST \
        -H 'Content-Type: application/json' \
        -H "Authorization: Bearer $ACCESS_TOKEN" \
        -H "data-partition-id: ${partitions_array[index]}" \
        -d "{\"email\":\"$ADMIN_ID\", \"role\": \"MEMBER\"}" \
        $OSDU_ENTITLEMENTS_ADD_OPS_URI)
      
      echo "Init Reponse: $init_response"
  
      if [ -z "$init_response" -a "$init_response"==" " ]; then
        echo "Add Ops Member Failed, Empty Reponse. Iteration $i."
        continue
      fi
  
      # Status code check. succeed only if 2xx
      # quit for partition if 404 or 400.
      # 401 or 403, then retry after getting access token.
      # else sleep for 1min and retry
      if [[ ${init_response} != *"Http_Status_Code:2"* ]] && [[ ${init_response} != *"Http_Status_Code:409"* ]];then
        if [[ ${init_response} == *"Http_Status_Code:400"* ]] || [[ ${init_response} == *"Http_Status_Code:404"* ]];then
          currentStatus="failure"
          currentMessage="${currentMessage}. Add Ops Member for partition ${partitions_array[index]} failed with response $init_response. "
          echo "Add Ops Member for partition ${partitions_array[index]} failed with response $init_response"
          break
        fi
  
        echo "Sleeping for 1min."
        sleep 1m
  
        if [[ ${init_response} == *"Http_Status_Code:401"* ]] || [[ ${init_response} == *"Http_Status_Code:403"* ]];then
          echo "Trying to Re-Fetch Access Token"
          ACCESS_TOKEN=$(sh ./get_access_token.sh)
          if [[ "$ACCESS_TOKEN" == "TOKEN_FETCH_FAILURE" ]]; then
            currentStatus="failure"
            currentMessage="${currentMessage}. Failure re-fetching Access Token. "
            echo "Failure re-fetching Access Token"
            break
          fi
          echo "Access Token re-fetched successfully."
        fi
  
        continue
      else
        if [[ ${init_response} == *"Http_Status_Code:409"* ]];then
          currentMessage="${currentMessage}. HTTP Status Code: 409 -> Admin User ${partitions_array[index]} Already Exists. "
          echo "HTTP Status Code: 409 -> Partition ${partitions_array[index]} Already Exists."
        fi
        currentMessage="${currentMessage}. Ops Member for Partition ${partitions_array[index]} Initialized successfully. "
        echo "Ops Member for Partition ${partitions_array[index]} Initialized successfully."
        partition_admin_initialized_count=$(expr $partition_admin_initialized_count + 1)
  
        break
      fi
    done

    if [[ $i -ge 3 ]]; then
      currentStatus="failure"
      currentMessage="${currentMessage}. Adding Admin User: Max Number of retries reached. "
    fi
  done
  
  if [ "$partition_count" -ne "$partition_initialized_count" ] || [ "$partition_user_initialized_count" -ne "$partition_initialized_count" ] || [ "$partition_admin_initialized_count" -ne "$partition_initialized_count" ]; then
    currentStatus="failure"
    currentMessage="${currentMessage}. Entitlements for $partition_initialized_count partition(s) of total $partition_count partition(s) initialized successfully. "
    currentMessage="${currentMessage}. $partition_user_initialized_count partition(s) of total $partition_initialized_count initialized with User. "
    currentMessage="${currentMessage}. $partition_admin_initialized_count partition(s) of total $partition_initialized_count initialized with Ops Member. "
    echo "Entitlements for $partition_initialized_count partition(s) of total $partition_count partition(s) initialized successfully."
    echo "$partition_user_initialized_count partition(s) of total $partition_initialized_count initialized with User."
    echo "$partition_admin_initialized_count partition(s) of total $partition_initialized_count initialized with Ops Member."
  else
    currentMessage="${currentMessage}. Entitlements for All $partition_initialized_count partition(s) initialized successfully. "
    currentMessage="${currentMessage}. User for all of $partition_user_initialized_count partition(s) added successfully. "
    currentMessage="${currentMessage}. Ops Members for all of $partition_admin_initialized_count partition(s) added successfully. "
    echo "Entitlements for All $partition_initialized_count partition(s) initialized successfully."
    echo "User for all of $partition_user_initialized_count partition(s) added successfully."
    echo "Ops Members for all of $partition_admin_initialized_count partition(s) added successfully."
  fi
fi

if [ -z "$currentStatus" -a "$currentStatus"==" " ]; then
    currentStatus="success"
fi
echo "Current Status: ${currentStatus}"
echo "Current Message: ${currentMessage}"

if [ ! -z "$CONFIG_MAP_NAME" -a "$CONFIG_MAP_NAME" != " " ]; then
  az login --identity --username $OSDU_IDENTITY_ID
  ENV_AKS=$(az aks list --resource-group $RESOURCE_GROUP_NAME --query [].name -otsv)
  az aks get-credentials --resource-group $RESOURCE_GROUP_NAME --name $ENV_AKS
  kubectl config set-context $RESOURCE_GROUP_NAME --cluster $ENV_AKS

  Status=$(kubectl get configmap $CONFIG_MAP_NAME -o jsonpath='{.data.status}')
  Message=$(kubectl get configmap $CONFIG_MAP_NAME -o jsonpath='{.data.message}')

  Message="${Message}Entitlements Init Message: ${currentMessage}. "

  ## Update ConfigMap
  kubectl create configmap $CONFIG_MAP_NAME \
    --from-literal=status="$currentStatus" \
    --from-literal=message="$Message" \
    -o yaml --dry-run=client | kubectl replace -f -
fi

if [[ ${currentStatus} == "success" ]]; then
    exit 0
else
    exit 1
fi