#!/bin/bash

# Strigo public IPs change, so best to just make a script to grab these
# Update these with your dynamic DNS names from Strigo
master_node_dns=nsxcczzcrqcdfqzt2-85xm4h5sqjd3urhvg.labs.strigo.io
worker_node_one_dns=nsxcczzcrqcdfqzt2-qppdb64dq4tuahs3j.labs.strigo.io
worker_node_two_dns=nsxcczzcrqcdfqzt2-erkmvm5wm39fvs8gp.labs.strigo.io

master_ip=$(dig +short $master_node_dns)
worker_one_ip=$(dig +short $worker_node_one_dns)
worker_two_ip=$(dig +short $worker_node_two_dns)

# Check if Strigo is actually running and we got IP addresses
if [ -z "$master_ip" ]
then  
    echo "Strigo DNS names given are not resolving to IP addresses"
    echo "Exiting the script, wait a bit for them to properly show up."
    exit 1
fi

# Clear out old values.yaml file
rm ./k8s/values.yaml
cat <<EOF > ./k8s/values.yaml
#@data/values
---
addresses:
- ${master_ip}/32
- ${worker_one_ip}/32
- ${worker_two_ip}/32
EOF

