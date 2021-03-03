# 3. Security Item - Implement Java Service Base Container

Date: 2021-02-11

## Status

Proposed

## Context

Currently the base image all java services are using is `openjdk:8-jdk-alpine`.  This presents an issue when it comes to security and meeting the requirement of the ability to perform container hardening as well as OS patching of the container.

## Decision

Implement an osdu-azure base container that we have control of so that we have the ability to perform any hardening or patching requests that come in.

This will additionally provide the capability to perform specific tasks that might be of benefit in the base container and have them applied to all java services.

Example:

1. Set JVM tuning parameters.
2. Implement Application Insights Java Agent

## Consequences

The code for the base container and hosting of the base container now needs to be managed.
