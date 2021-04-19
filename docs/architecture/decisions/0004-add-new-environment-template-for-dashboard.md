# 4. Add environment template for dashboard

Date: 2021-02-16

## Status

Accepted

## Context

A dashboard is used for monitoring other resources or pinning them on a tile for quick access. Dashboards reference frequently the fully qualified ID of the resource,
including the resource name and resource type.  Format: `/subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}`. By virtue of this, it requires those resource names to exist and be passed to it at the time of creation. Resources are created with 3 seperated terraform templates that also have a creation order.

1. Central Resources  -- No Dependencies.
2. Data Partition -- Depends on Central Resources
3. Service Resources -- Depends on Central Resources

A dashboard created by Terraform would be required to be created last in order to bring in the state of other templates to have available the naming conventions, or it could be a fully independent item and naming conventions then submitted as criteria.

## Decision

A new terraform template will be created for dashboards.


## Consequences

Dashboards will be an opt in feature.
Dashboards can only be created after resources exist.
Dashboards will break and have to be updated if the resourceId of the resources displayed are changed.
