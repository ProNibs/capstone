#!/bin/bash

# Strigo public IPs change, so best to just make a script to grab these
# Update these with your dynamic DNS names from Strigo
master_node_dns=nsxcczzcrqcdfqzt2-85xm4h5sqjd3urhvg.labs.strigo.io
worker_node_one_dns=nsxcczzcrqcdfqzt2-qppdb64dq4tuahs3j.labs.strigo.io
worker_node_two_dns=nsxcczzcrqcdfqzt2-erkmvm5wm39fvs8gp.labs.strigo.io

export master_ip=$(dig +short $master_node_dns)
export worker_one_ip=$(dig +short $worker_node_one_dns)
export worker_two_ip=$(dig +short $worker_node_two_dns)

# Execute via source to get these environment variables usable