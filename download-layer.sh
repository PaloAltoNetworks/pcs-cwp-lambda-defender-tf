#!/bin/bash

# Exit if any of the intermediate steps fail
set -e

# Extract "pcc_url", "pcc_user", "pcc_pass", "filename" and "runtime" arguments from the input into
eval "$(jq -r '@sh "PCC_URL=\(.pcc_url) PCC_USER=\(.pcc_user) PCC_PASS=\(.pcc_pass) FILENAME=\(.filename) RUNTIME=\(.runtime)"')"

# Get the Console Address if it does not exists
[[ -z "${PCC_SAN}" ]] && PCC_SAN="$(echo $PCC_URL | awk -F[/:] '{print $4}')"

# Generate token
TOKEN=$(curl -k -H "Content-Type: application/json" -X POST -d '{"username":"'$PCC_USER'","password":"'"$PCC_PASS"'"}' ${PCC_URL}/api/v1/authenticate | jq -r '.token')

# Generate TW_POLICY variable
curl -k -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" -s "$PCC_URL/api/v1/images/twistlock_defender_layer.zip" -o "$FILENAME" -d '{"runtime":"'$RUNTIME'","provider":"aws"}'

# Safely produce a JSON object containing the result value.
jq -n --arg filename "$FILENAME" '{"filename":$filename}'