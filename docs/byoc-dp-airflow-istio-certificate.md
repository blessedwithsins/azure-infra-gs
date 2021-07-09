# Bring your own certificate using Keyvault on Istio Gateway for Data partition Airflow

The feature enables the customers to manage and provision SSL certificates used by airflow cluster provisioned in data partition

### Creating BYOC certificate using letsencrypt

**You can skip this step if you already have a readiy available SSL certificate which you want to configure**

Below are the instructions to create a letsencrypt certificate compatable with azure keyvault.

1. Run the below docker command and follow the instructions to generate the SSL certificate
```bash
docker run -it --rm --name letsencrypt -v /etc/letsencrypt:/etc/letsencrypt -v /var/lib/letsencrypt:/var/lib/letsencrypt certbot/certbot:latest certonly -d "<AIRFLOW_DNS_NAME>" --manual --preferred-challenges dns --server https://acme-v02.api.letsencrypt.org/directory
```

2. Go to `/etc/letsencrypt/live/<AIRFLOW_DNS_NAME>`. All the files needed for SSL certificate are present here

3. To create a .pem file which is compatable with Keyvault, run the below command
```bash
cat cert.pem fullchain.pem privkey.pem > full-cert-keyvault.pem
```

4. Use `full-cert-keyvault.pem` while uploading the certificate to keyvault



### Upload your own certificate 

##### Using  Azure Portal
1. Open Azure portal and navigate to the data partition resource group

2. Open keyvault named `osdu-mvp-xxx-xxxx-kv`.

2. Make sure you have all the permission on **Certificate Management**. Go access policies by selecting on **_Access Policies_** option on left subsection.
   Provide yourself necessary permissions on Certificate Management.
   
3. Once you have view and update permission on Certificate, click Certificates on left subsections.

4. Click on `+ Generate/Import`

5. Select method of certicate creation as `Import`

6. Input certificate name as `istio-ssl-certificate`

7. Upload the certificate file. Follow  the link  [Keyvault certificates](https://docs.microsoft.com/en-us/azure/key-vault/certificates/certificate-scenarios) to know more about certificate generation/upload.

6. Click `Create` and wait until the certificate gets created in Keyvault.

##### Using Azure Command Line
Please run the following command after doing az login with your subscription

```bash
FILE_PATH=""     # local path to file, must follow the format rules. <br>
CERT_NAME="istio-ssl-certificate"   #<br>
VAULT_NAME="osdu-mvp-xxx-xxxx-kv"  # Modify vault name <br>
az keyvault certificate create --vault-name $VAULT_NAME --name $CERT_NAME \
  --policy "$(az keyvault certificate get-default-policy)"
az keyvault certificate import --file $FILE_PATH --name $CERT_NAME --vault-name $VAULT_NAME`
```


## Automated Pipelines - BYOC Guide
### Use uploaded certificate

1. Once upload is complete, Go to Azure Devops Project that you have set up for code mirroring.

2. Setup library variable `DP_ENABLE_KEYVAULT_CERT` in Variable group **Azure Target Env Data Partition opendes - demo**
   to `true`.
   
3. Run the pipeline manually for data partition airflow for master branch `chart-airflow-opendes`
   
5. Access daata partition airflow with DNS configured, validate in the browser that certificate used is the one which was uploaded.
