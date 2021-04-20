# Identity Provider Integration Through Envoy Filters
## Summary
In order to support multiple identity providers (IdP), a pluggable framework has been implemented to handle bearer tokens.  This framework is implemented at the service mesh layer, reducing the need for changes to the service source and insulating service code from the complexity of managing tokens from different identity providers.  

## Istio for Request Authentication
An Istio `RequestAuthentication` object is used to authenticate bearer tokens provided with requests.  The default Azure-OSDU implementations recognize tokens for an (environment-specific) Azure subscription providers `login.microsoftonline.com` and `sts.windows.net`.  Other providers can be added as needed.  With this object, bearer tokens are automatically validated by Istio.  When paired with Istio `AuthorizationPolicy` objects, we apply a demand for a valid bearer token to incoming requests and automatically reject those which do not include a valid recognized token.

## Istio for Identity Extraction
Because the bearer token is available at the Istio layer, and the bearer token is guaranteed to be validated by the `RequestAuthentication` object, we can use Envoy to encapsulate the provider-specific logic of extracting identity information from the tokens.  Without this, IdP-specific logic would need to reside in the Entitlements service and would need to be updated each time a new identity provider was added to the `RequestAuthentication` object.  This makes an unpleasant tight coupling between service source code and deployment configuration.  

Instead, the framework will add HTTP headers with each request.  These headers contain the validated user identity from the token.  HTTP Request header handling is already part of the service frameworks.  The Istio framework can provide several guarantees:
1. A request must provide a validated bearer token to be forwarded to the service
1. A well-known request header will be generated with the identity from the bearer token according to provider-specific logic
1. The well-known request header will only be forwarded to the service if its content has come from the bearer token
1. If no token has been supplied, or if the token does not contain identity information, the well-known header will not be forwarded

With these guarantees in place, the consuming services can trust the well-known header presented to them and eliminate any need to interact with the bearer token directly.  

## Process
A set of Envoy filters are installed as part of the infrastructure configuration.  These filters are defined in the `envoy-idp-user-headers.yaml` file.  Replacement parameters are included so the object will be configured to match the `RequestAuthentication` settings automatically.  
1. These filters are configured to *chain* so that they execute in sequence
1. In particular, the filters are installed so that all provider-specific filters *chain* to execute after the default filter
1. The default filter only strips out the well-known headers if included with an incoming request
1. After that, each provider-specific filter is executed serially but in no deterministic order
1. Each provider-specific filter should recognize and process only tokens from its provider
1. The specific attribute(s) from the token which comprise *identity* are known to the filter and should be extracted to the well-known header
1. A filter must not alter the well-known header if it does not handle the bearer token (because the token comes from a different provider)

## Implementation Details

### Well-Known Headers
The `Entitlements` service expects two identity-related values: `user-id` and `app-id`.  These are provided in two distinct headers: `x-user-id` and `x-app-id` (respectively).  As described above, the filter logic will ensure that these headers are forwarded to the service if, and only if, the values were extracted from a recognized valid bearer token. 

### Default Implementation: Removing Well-Known Headers
The first filter to be executed will remove the `x-app-id` and `x-user-id` headers from every request.  This guarantees that, if the headers are present when the request reaches the service, then they have been validated and can be trusted.  

### Default Implementation: `sts.windows.net`
The default implementation for tokens issued by `sts.windows.net` is as follows:
- The `x-app-id` header will contain the value of the `aud` claim.  The `aud` claim is always expected to exist. 
- the `x-user-id` header will use the value of the first existing claim from the following list.  If none of these claims is present, the `x-user-id` header will not be present.
    1. `upn`
    1. `unique_name`
    1. `appid`

Given the following [example token](https://docs.microsoft.com/en-us/azure/active-directory/develop/access-tokens), the well-known header values would be set as follows:

```
x-app-id: ef1da9d4-ff77-4c3e-a005-840c3f830745
x-user-id: abeli@microsoft.com
```

**Example Token**
```
{
  "aud": "ef1da9d4-ff77-4c3e-a005-840c3f830745",
  "iss": "https://sts.windows.net/fa15d692-e9c7-4460-a743-29f29522229/",
  "iat": 1537233106,
  "nbf": 1537233106,
  "exp": 1537237006,
  "acr": "1",
  "aio": "AXQAi/8IAAAAFm+E/QTG+gFnVxLjWdw8K+61AGrSOuMMF6ebaMj7XO3IbmD3fGmrOyD+NvZyGn2VaT/kDKXw4MIhrgGVq6Bn8wLXoT1LkIZ+FzQVkJPPLQOV4KcXqSlCVPDS/DiCDgE222TImMvWNaEMaUOTsIGvTQ==",
  "amr": [
    "wia"
  ],
  "appid": "75dbe77f-10a3-4e59-85fd-8c127544f17c",
  "appidacr": "0",
  "email": "AbeLi@microsoft.com",
  "family_name": "Lincoln",
  "given_name": "Abe (MSFT)",
  "idp": "https://sts.windows.net/72f988bf-86f1-41af-91ab-2d7cd0122247/",
  "ipaddr": "222.222.222.22",
  "name": "abeli",
  "oid": "02223b6b-aa1d-42d4-9ec0-1b2bb9194438",
  "rh": "I",
  "scp": "user_impersonation",
  "sub": "l3_roISQU222bULS9yi2k0XpqpOiMz5H3ZACo1GeXA",
  "tid": "fa15d692-e9c7-4460-a743-29f2956fd429",
  "unique_name": "abeli@microsoft.com",
  "uti": "FVsGxYXI30-TuikuuUoFAA",
  "ver": "1.0"
}
```

### Default Implementation: `login.microsoftonline.com`
The default implementation for tokens issued by `login.microsoftonline.com` is as follows:
- The `x-app-id` header will contain the value of the `aud` claim.  The `aud` claim is always expected to exist. 
- the `x-user-id` header will use the value of the first existing claim from the following list.  If none of these claims is present, the `x-user-id` header will not be present.
    1. `oid`
    1. `azp`

Given the following [example token](https://docs.microsoft.com/en-us/azure/active-directory/develop/access-tokens), the well-known header values would be set as follows:

```
x-app-id: 6e74172b-be56-4843-9ff4-e66a39bb12e3
x-user-id: 690222be-ff1a-4d56-abd1-7e4f7d38e474
```

**Example Token**
```
{
  "aud": "6e74172b-be56-4843-9ff4-e66a39bb12e3",
  "iss": "https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/v2.0",
  "iat": 1537231048,
  "nbf": 1537231048,
  "exp": 1537234948,
  "aio": "AXQAi/8IAAAAtAaZLo3ChMif6KOnttRB7eBq4/DccQzjcJGxPYy/C3jDaNGxXd6wNIIVGRghNRnwJ1lOcAnNZcjvkoyrFxCttv33140RioOFJ4bCCGVuoCag1uOTT22222gHwLPYQ/uf79QX+0KIijdrmp69RctzmQ==",
  "azp": "6e74172b-be56-4843-9ff4-e66a39bb12e3",
  "azpacr": "0",
  "name": "Abe Lincoln",
  "oid": "690222be-ff1a-4d56-abd1-7e4f7d38e474",
  "preferred_username": "abeli@microsoft.com",
  "rh": "I",
  "scp": "access_as_user",
  "sub": "HKZpfaHyWadeOouYlitjrI-KffTm222X5rrV3xDqfKQ",
  "tid": "72f988bf-86f1-41af-91ab-2d7cd011db47",
  "uti": "fqiBqXLPj0eQa82S-IYFAA",
  "ver": "2.0"
}
```

### Custom Implementation
An update to the `RequestAuthentication` object to include a new identity provider will require the addition of a new Envoy filter.  The new filter should be added to the `envoy-idp-user-headers.yaml` (to ensure correct application order using `kubectl`).  Use one of the existing filters for a template and make the following changes:
- Update the `metadata.name` attribute of the Kubernetes object to supply a unique name.  Ensure that the name is alphabetically greater than `header-1-remove-user-appid-from-default`.  A recommendation is to use sequential numbers to help ensure that IdP filters are applied after the first filter. 
- Update the `spec.configPatches.patch.value.name` attribute to give a unique name to the Envoy object created by the Kubernetes definition.  
- Validate that the `spec.configPatches.match.listener.filterChain.filter.subFilter` attribute specifies the `envoy.lua.remove-user-appid-header` filter.  
- Modify `spec.configPatches.patch.value.typed_config.inlineCode` attribute to include your custom Lua code.  This code should:
    - Match only tokens from your identity provider
    - Set `x-app-id` and `x-user-id` headers based on claims from your token
    - If expected claims are not present, the header(s) should not be set

Explanation of the Lua language, and the logic required for your identity provider, are beyond the scope of this document.

### Special Notes (Troubleshooting)
A few notes about issues that have appeared during implementation.
- The first filter, which strips headers from requests, **must** be present in the system or the filter chaining will silently fail.  This filter **must** be created before the other filters are added.  
- Some CI/CD automation may have side-effects that can break the requirement above.  
    - Using `kubectl` to install the filters should be done with caution.  All filters are present in a single file `envoy-idp-user-headers.yaml` and in general, the filters will be added in order from top to bottom.  Be cautious of modifying the order within the file.  When in doubt, delete all filters and re-apply.  
    - Using automation with FluxCD does not preserve the order of the envoy filters from the `envoy-idp-user-headers.yaml` file.  Instead, Flux uses its own process to determine the order in which Kubernetes objects are applied, which appears to be *alphabetical*.  It is important that the names of the Kubernetes objects adhere strictly to this alphabetical ordering.  
- Errors in the Lua source for the filter will not be detected by `kubectl`.  The filter will not be accepted by Envoy, but no error message will be returned.  Examine the Envoy logs from the `istio-proxy` container directly.  
- As noted above, ordering of the Envoy filters is generally unimportant except that the first filter must be created before all of the others.  If this filter is removed (even to replace it) then all of the other filters must be removed and re-created as well.