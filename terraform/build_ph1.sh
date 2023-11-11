#!/bin/sh
source .env

cd ./phase1/
terraform init
terraform plan
terraform apply -auto-approve
# terraform output -json > ../phase2/output.json