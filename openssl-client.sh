#!/bin/bash

# Variables
    config=config/client.cnf
    cert_user=certs
    ca_key=ca/ca.key
    ca_crt=ca/ca.crt
    ca_crl=ca/ca.crl

# Function to generate a new certificate in PKCS format
generate_certificate() {
    
    read -p "Enter the name for the user: " user_name
    read -p "Enter the number of days the certificate should be valid for: " validity_days

    certificate_name=$user_name
    
openssl req \
   -new \
   -subj "/CN=$user_name" \
   -keyout $cert_user/$certificate_name.key \
   -nodes \
   -out $cert_user/$certificate_name.csr \
   -config $config

openssl \
    x509 \
   -req \
   -days $validity_days \
   -in $cert_user/$certificate_name.csr \
   -out $cert_user/$certificate_name.crt \
   -CA $ca_crt \
   -CAkey $ca_key \
   -set_serial 0x"$(openssl rand -hex 16)" \
   -extensions client_extensions \
   -extfile $config

openssl pkcs12 \
   -export \
   -out $cert_user/$certificate_name.p12 \
   -inkey $cert_user/$certificate_name.key \
   -in $cert_user/$certificate_name.crt \
   -certfile $ca_crt   

    echo "Certificate have been generated for User $user_name." && exit
}

# Function to revoke and delete a certificate
revoke_and_delete_certificate() {
    
    echo "Revoking and Deleting Certificate:"
    read -rp "Enter the certificate name (without extension): " user_name

    certificate_name=$user_name
   
openssl ca \
    -revoke $cert_user/$certificate_name.crt \
    -keyfile $ca_key \
    -cert $ca_crt \
    -config $config
    
openssl ca \
    -gencrl \
    -keyfile $ca_key \
    -cert $ca_crt \
    -out $ca_crl \
    -config $config
    
    echo "Certificate has been revoked and added to the Certificate Revocation List (CRL) for User $user_name."
    rm -f $cert_user/$certificate_name.key $cert_user/$certificate_name.csr $cert_user/$certificate_name.crt $cert_user/$certificate_name.p12
    echo "Certificate files for User $user_name have been deleted." && exit
}

# Function to list existing users
list_users() {
    print_horizontal_line() {
        printf "+----------------+\n"
}
    print_column() {
        printf "| %-14s |\n" "$1"
}
    print_horizontal_line
        printf "| Existing users |\n"
    print_horizontal_line

    for certificate in "$cert_user"/*.p12; do
        user_name="${certificate#${cert_user}/}"
        user_name="${user_name%.p12}"    
    print_column "$user_name"
    done

    print_horizontal_line
}

# Main menu
while true; do
    echo "Menu:"
    echo "1. Generate new certificate"
    echo "2. Revoke and delete a certificate"
    echo "3. List users"
    echo "4. Exit"
    read -p "Enter your choice: " choice

    case $choice in
        1)
            generate_certificate
            ;;
        2)
            revoke_and_delete_certificate
            ;;
        3)
            list_users
            ;;
        4)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please try again."
            ;;
    esac
done