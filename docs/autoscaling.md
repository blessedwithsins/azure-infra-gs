# Autoscaling support and configuration

Explanation of decision to add autoscaling in setup and details of setup located in this [issue](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/167).

Autoscaling is not enabled by default and has a feature flag to enable it and create related resources. You can find it in `variables.tf` file in service_resources module [infra\templates\osdu-r3-mvp\service_resources\variables.tf](\infra\templates\osdu-r3-mvp\service_resources\variables.tf) and in `terraform.tfvars` [infra\templates\osdu-r3-mvp\service_resources\terraform.tfvars](infra\templates\osdu-r3-mvp\service_resources\terraform.tfvars).

```
variable "feature_flag" {
  description = "(Optional) A toggle for incubator features"
  type = object({
    osdu_namespace = bool
    flux           = bool
    sa_lock        = bool
    autoscaling    = bool

  })
  default = {
    osdu_namespace = true
    flux           = true
    sa_lock        = true
    autoscaling    = false
  }
}
```
To set up Istio to work with autoscaling you should set `isAutoscalingEnabled` flag to **true** in `helm-config.yaml` [charts\helm-config.yaml](charts\helm-config.yaml).

### Configuration

To configure autoscaling you should add the following variables group in **the ADO Library** `Infrastructure Pipeline Variables - <env>`. 

| Variable                              | eg. Value             |
| ------------------------------------- | --------------------- |
| TF_VAR_aks_services_agent_vm_count    | 3                     |
| TF_VAR_aks_services_agent_vm_maxcount | 7                     |
| TF_VAR_aks_services_agent_vm_size     | Standard_D8s_v3       |
| TF_VAR_aks_dns_host                   | demo.osdu.contoso.com |
| TF_VAR_istio_int_load_balancer_ip     | 10.10.255.253         |

The variable `TF_VAR_istio_int_load_balancer_ip` will be used to configure internal LB for Istio. Any free IP address should be chosen from address space used in `TF_var_ address_space` terraform variable. Value of `TF_VAR_istio_int_load_balancer_ip` will be placed in key vault secret and **have to be** linked in the ADO Library `Azure Target Env Secrets - <env>`

``TF_VAR_aks_dns_host` should have the same value as `DNS_HOST` variable in  `Azure Target Env - <env>`  and should contain your ingress hostname.

## Bring your own certificate using Keyvault on Istio ingress controller

The feature enables the customers to manage and provision certificates used on the frontend of OSDU.

In this approach, we use certificate uploaded by customer to Keyvault.

### Upload your own certificate in case of autoscaling is enabled
1. Open Azure portal and open keyvault named `osdu-mvp-crxxx-xxxx-kv`.

2. Make sure you have all the permission on **Certificate Management**. Go access policies by selecting on **_Access Policies_** option on left subsection.
   Provide yourself necessary permissions on Certificate Management.
   
3. Once you have view and update permission on Certificate, click Certificates on left subsections.

4. Select Certificate named **`appgw-ssl-cert`**. 

5. Click `+ New Version`. Select `Generate` or `Import` based on your preference and certificate you want to provision/upload.
   Follow  the link  [Keyvault certificates](https://docs.microsoft.com/en-us/azure/key-vault/certificates/certificate-scenarios) to know more about certificate generation/upload.

6. Click `Create` and wait until the certificate gets created in Keyvault.

###  Use uploaded certificate

1. Once upload is complete, Go to Azure Devops Project that you have set up for code mirroring.
2. Setup library variable `ENABLE_ISTIO_KEYVAULT_CERT` in Variable group **Azure - OSDU**
   to `true`.
3. Run the pipeline following pipeline manually for master branch:
   - `osdu-istio` 
4. Access OSDU with DNS configured, validate in the browser that certificate used is the one which was uploaded. 

