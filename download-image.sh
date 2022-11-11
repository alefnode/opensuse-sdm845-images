#!/bin/bash
set -e 

source .env

echo "Download ${OPENSUSE_RAW_SOURCE}/${OPENSUSE_RAW_FILE}"

wget -c "${OPENSUSE_RAW_SOURCE}/${OPENSUSE_RAW_FILE}"


