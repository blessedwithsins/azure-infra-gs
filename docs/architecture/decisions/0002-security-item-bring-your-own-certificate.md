# 2. Security Item - Bring your own certificate

Date: 2021-02-11

## Status

Proposed

## Context

In current OSDU setup we use Kubernetes CertManager to manage SSL certificates. The CA through which these certificates are being provisioned is Letsencrypt. We need to propose ways in which we can help the customer to manage and provision these certificates.

### Current State - Automatic Cert Provisioning with cert-manager

Cert-manager is a native Kubernetes certificate management controller. It can help with issuing certificates from a variety of sources, such as Let’s Encrypt, HashiCorp Vault, Venafi, a simple signing key pair, or self-signed. This solution is best suited for the customers who doesn’t want to bring their own certificate. The Cert manager will order, provision, and renew certificates for such cases.

__Pros:__

1. Automated provisioning and renewal of certificates.

__Cons:__

1. Support for custom certificate vendor requires additional effort. Modification in helm charts is required based on the type of vendor.


### Manual Workaround - Front Door

Azure Front Door is a global, scalable entry-point that uses the Microsoft global edge network to create fast, secure, and widely scalable web applications. There are two ways in which Front door can be used to handle SSL certificates:

1. Using Azure Managed Certificates: Azure Front Door completely handles certificate management tasks such as procurement and renewal. It can be configured directly through portal.

2. Using Custom Certificate:  This process is done through an integration with Azure Key Vault, which allows you to store your certificates securely. Azure Front Door uses this secure mechanism to get your certificate and it requires a few additional steps. When you create your TLS/SSL certificate, you must create it with an allowed certificate authority (CA).

__Pros:__

1. Simple steps to utilize Azure managed certificates.
2. Automated renewal of Azure managed certificates.

__Cons:__

1. An extra routing layer, Front Door, needs to be added on top of existing Application Gateway.
2. Requires double encryption as it is a global resource and if the backend resources are hosted on Public IP.


### Using Application Gateway along with Key Vault

Azure Application Gateway supports integration with Key Vault for server certificates that are attached to HTTPS-enabled listeners. Application Gateway currently supports software-validated certificates only. Hardware security module (HSM)-validated certificates are not supported. After Application Gateway is configured to use Key Vault certificates, its instances retrieve the certificate from Key Vault and install them locally for TLS termination. The instances also poll Key Vault at 4-hour intervals to retrieve a renewed version of the certificate if it exists. If an updated certificate is found, the TLS/SSL certificate currently associated with the HTTPS listener is automatically rotated.

__Pros:__

1. Stronger security because TLS/SSL certificates aren't directly handled by the application development team. Integration allows a separate security team to:
  - Set up application gateways.
  - Control application gateway lifecycles.
  - Grant permissions to selected application gateways to access certificates that are stored in your key vault.

2. Support for importing existing certificates into your key vault. Or use Key Vault APIs to create and manage new certificates with any of the trusted Key Vault partners.

3. Support for automatic renewal of certificates that are stored in your key vault.

__Cons:__

1. When using Key Vault with Application Gateway, customers will need to select "Public endpoint (all networks)" when configuring the networking section on Key Vault. Application Gateway currently does not support integration with Key Vault if Key Vault is not configured to allow "Public endpoints (all networks)" access.

## Decision

Customers who don’t have any specific TLS requirement, can continue to use existing setup of getting certificates using Cert Manager which will take care of procurements and managing of the certificate.

Customers who want their own TLS certificate to be used and don't plan on using Front Door, we recommend approach `Using Application Gateway along with Key Vault`

## Consequences

Certificates would have to be introduced and fed to infrastructure at the time of infrastructure creation.
