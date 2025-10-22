#!/bin/bash
set -e 

source .env

PATTERN="openSUSE-Tumbleweed-ARM-${DESKTOP}-${DEVICE}.aarch64"
LATEST_FILE=$(curl -s "$BASE_URL/" \
  | grep -oE "${PATTERN}-[0-9.]+-Build[0-9.]+\.raw\.xz" \
  | sort -rV \
  | head -n1)

if [[ -z "$LATEST_FILE" ]]; then
  echo "❌ Do not exists any image with pattern '$PATTERN'."
  exit 1
fi

echo "✅ Last image found:"
echo "   Archivo: $LATEST_FILE"
echo "   URL:     ${BASE_URL}/${LATEST_FILE}"
echo

echo "Download ${OPENSUSE_RAW_SOURCE}/${OPENSUSE_RAW_FILE}"

wget -c "${BASE_URL}/${LATEST_FILE}"

mv ${LATEST_FILE} ${OPENSUSE_RAW_FILE}

