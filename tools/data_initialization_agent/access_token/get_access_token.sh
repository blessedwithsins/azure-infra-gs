#!/bin/bash

i=0

while [[ $i -lt 3 ]]; do
    i=$(expr $i + 1)

    response=$(curl 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fmanagement.azure.com%2F' -H Metadata:true -s)

    if [ -z "$response" -a "$response"==" " ]; then
        continue
    fi

    # Get Access Token
    access_token=$(echo $response | python -c 'import sys, json; print (json.load(sys.stdin)["access_token"])')
    if [ ! -z "$access_token" -a "$access_token" != " " ]; then
        echo $access_token
        exit 0
    fi
done

echo "TOKEN_FETCH_FAILURE"
exit 1