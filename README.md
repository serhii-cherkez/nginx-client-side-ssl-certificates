# Nginx client-side SSL certificates script

## Usage

First, get the script and make it executable:
```
git clone https://github.com/serhii-cherkez/nginx-client-side-ssl-certificates.git 
cd nginx-client-side-ssl-certificates
chmod + x openssl-ca.sh openssl-clinet.sh
```

Then run **openssl-ca.sh** to create CA certificates:
```
./openssl-ca.sh
```

When CA certificates is created, you can run **openssl-client.sh**, and you will get the choice to:
```
./openssl-client.sh
```

+ Generate new certificate
+ Revoke and delete a certificate
+ List users
+ Exit

Run Generate new certificate. In your **certs** directory, you will have **.csr .crt .key .p12** files. These are the client configuration files. Download and import **.p12** to client PC.
