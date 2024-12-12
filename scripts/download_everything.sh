#!/bin/bash

set -o errexit

echo "Fetching dependencies"
./mvnw dependency:go-offline

echo "Fetching docker images"
docker compose pull
pushd week3/part1
  docker compose pull
popd

echo "Running KIND"
kind delete cluster || echo "Already deleted"
./week1/part4/boot-k8s/k8s/kind-with-registry.sh
kind delete cluster || echo "Already deleted"

echo "Checking if Vault CLI is installed"
# https://developer.hashicorp.com/vault/tutorials/getting-started/getting-started-install
vaultMissing="false"
vault --version || echo "Vault missing" && vaultMissing="true"
if [[ "${vaultMissing}" == "false" ]]; then
  echo "Please check https://developer.hashicorp.com/vault/tutorials/getting-started/getting-started-install on how to install Vault"
fi
