#!/bin/bash

# Exit if any of the intermediate steps fail
set -e

# Extract "pcc_url", "pcc_user", "pcc_pass", "pcc_san" and "function_name" arguments from the input into
eval "$(jq -r '@sh "PCC_URL=\(.pcc_url) PCC_USER=\(.pcc_user) PCC_PASS=\(.pcc_pass) F_NAME=\(.function_name) PCC_SAN=\(.pcc_san)"')"

# Get the Console Address if it does not exists
[[ -z "${PCC_SAN}" ]] && PCC_SAN="$(echo $PCC_URL | awk -F[/:] '{print $4}')"

# Generate token
TOKEN=$(curl -k -H "Content-Type: application/json" -X POST -d '{"username":"'$PCC_USER'","password":"'"$PCC_PASS"'"}' ${PCC_URL}/api/v1/authenticate | jq -r '.token')

# Generate TW_POLICY variable
TW_POLiCY=$(curl -k -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" -s ${PCC_URL}/api/v1/policies/runtime/serverless/encode -d '{"consoleAddr":"'"$PCC_SAN"'","function":"'"$F_NAME"'","provider":"aws"}' | jq -r '.data')

# Safely produce a JSON object containing the result value.
jq -n --arg tw_policy "$TW_POLiCY" '{"tw_policy":$tw_policy}'