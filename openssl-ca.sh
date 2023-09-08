#!/bin/bash

# Variables
     config_ca=config/ca.cnf 
     ca_key=ca/ca.key
     ca_crt=ca/ca.crt
     ca_crl=ca/ca.crl

# Function to generate a new CA certificate
openssl req \
    -x509 \
    -newkey rsa:4096 \
    -nodes \
    -keyout $ca_key \
    -out $ca_crt \
    -config $config_ca \
    -sha256 \
    -days 3650 