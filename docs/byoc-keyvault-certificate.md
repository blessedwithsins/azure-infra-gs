# Bring your own certificate using Keyvault on Application Gateway Ingress

The feature enables the customers to manage and provision certificates used on the frontend of OSDU.

In this approach, we use certificate uploaded by customer to Keyvault. 


### Upload your own certificate 

##### Using  Azure Portal
1. Open Azure portal and open keyvault named `osdu-mvp-crxxx-xxxx-kv`.

2. Make sure you have all the permission on **Certificate Management**. Go access policies by selecting on **_Access Policies_** option on left subsection.
   Provide yourself necessary permissions on Certificate Management.
   
3. Once you have view and update permission on Certificate, click Certificates on left subsections.

4. Select Certificate named **`appgw-ssl-cert`**. 

5. Click `+ New Version`. Select `Generate` or `Import` based on your preference and certificate you want to provision/upload.
   Follow  the link  [Keyvault certificates](https://docs.microsoft.com/en-us/azure/key-vault/certificates/certificate-scenarios) to know more about certificate generation/upload.

6. Click `Create` and wait until the certificate gets created in Keyvault.

##### Using Azure Command Line
Please run the following command after doing az login with your subscription

FILE_PATH=""     # local path to file, must follow the format rules. <br>
CERT_NAME="appgw-ssl-cert"   #<br>
VAULT_NAME="osdu-mvp-crxxx-xxxx-kv"  # Modify vault name <br>
`az keyvault certificate import --file $FILE_PATH --name $CERT_NAME --vault-name $VAULT_NAME`


## Automated Pipelines - BYOC Guide
### Use uploaded certificate

1. Once upload is complete, Go to Azure Devops Project that you have set up for code mirroring.

2. Setup library variable `ENABLE_KEYVAULT_CERT` in Variable group **Azure - OSDU**
   to `true`.
   
3. Run the pipeline following pipelines manually for master branch:<br>
   a. `chart-airflow` <br>
   b. `chart-osdu-common` 
   
4. Go to `k8-gitops-manifests` repo in ADO Project, look for file **`appgw-ingress.yaml`**.
   Make sure the ingress has annotation **appgw.ingress.kubernetes.io/appgw-ssl-certificate: "appgw-ssl-cert"** 
   and latest commit has flux sync tag.
   
5. Access OSDU with DNS configured, validate in the browser that certificate used is the one which was uploaded.

## Manual Installation - BYOC Guide

1. Go to [helm-charts-azure](https://community.opengroup.org/osdu/platform/deployment-and-operations/helm-charts-azure)
2. Modify the value **enableKeyvaultCert** to **true** in helm-configs mentioned in Readme.md and for airflow follow the README.md for airflow
   to install your uploaded certificate.
3. Do an installation of charts on Kubenetes environement.

Test the implementation by accessing the DNS_HOST and validating the certificate.
