#!/usr/bin/env bash
#
# Sets up local HTTPS for the apidemo.local domain:
#   1. Installs the mkcert local CA (idempotent)
#   2. Generates a trusted cert for apidemo.local into docker/certs/
#   3. Adds an /etc/hosts entry for apidemo.local (requires sudo)
#
set -euo pipefail

DOMAIN="apidemo.local"
CERT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/docker/certs"

if ! command -v mkcert >/dev/null 2>&1; then
    echo "mkcert is not installed. On macOS run: brew install mkcert nss" >&2
    exit 1
fi

echo "==> Installing mkcert local CA (idempotent)"
mkcert -install

echo "==> Generating certificate for ${DOMAIN}"
mkdir -p "${CERT_DIR}"
mkcert -cert-file "${CERT_DIR}/${DOMAIN}.pem" \
    -key-file "${CERT_DIR}/${DOMAIN}-key.pem" \
    "${DOMAIN}"

if grep -q "[[:space:]]${DOMAIN}\$" /etc/hosts; then
    echo "==> /etc/hosts already contains ${DOMAIN}"
else
    echo "==> Adding ${DOMAIN} to /etc/hosts (requires sudo)"
    echo "127.0.0.1 ${DOMAIN}" | sudo tee -a /etc/hosts >/dev/null
fi

echo "==> Done. Start the stack with: docker compose up -d --build"
echo "    Then visit: https://${DOMAIN}"
