# 5. Add alert rules under monitoring resources

Date: 2021-04-07

## Status

Proposed

## Context

An alert rule references the fully qualified ID of the resource it monitors, format: `/subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}`.
By virtue of this, it requires the resource name to exist and be passed to it at the time of creation.

## Decision

We will add alert rules as part of the monitoring resources.


## Consequences

Alert will be an opt in feature.
Alert can only be created after resources exist.
Alert will break and have to be updated if the resourceId of the resource being monitored is changed.
