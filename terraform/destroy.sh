#!/bin/sh
source .env

cd ./phase1/
terraform destroy

# cd ./phase2/
# terraform destroy -var-file=./output.json
# cd ../phase1/
# terraform destroy