[[_TOC_]]

## Conditions

While trying to create new subscriptions using the Register Service endpoint, you have encountered the error message

`register.app Creating Push Subscription failed with error: com.microsoft.azure.CloudException: Async operation failed with provisioning state: Failed: Access check failed for Webhook AAD App with error 'Subscriber's client aad application with object id '<PLACEHOLDER>' is neither owner of this AAD application <PLACEHOLDER> nor have this role AzureEventGridSecureWebhookSubscriber. In addition the role has to be assigned to client aad application with object if '<PLACEHOLDER>'. One of these two conditions has to be met.'. For troublehooting, visit https://aka.ms/essecurewebhook. Activity id:<PLACEHOLDER>, timestamp: 4/13/2021 2:03:53 AM (UTC). {correlation-id=<PLACEHOLDER>, data-partition-id=<PLACEHOLDER>}	`


## Mitigation Recommended
The `docs\Trouble Shooting Guides\tsg-scripts\subscriberCreationRegisterService.ps1` script can be utilized. For more information refer to https://aka.ms/essecurewebhook. 

**How to run the script?** 
Use Azure portal's (UI) shell - PowerShell to run this script. An owner for the subscription can run this script.

Use Terraform Service Principal to login to Powershell, alternativey.    