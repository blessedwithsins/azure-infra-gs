# OSDU on Azure Release Management

Release Management is an opinionated topic and this documentation is meant as some initial guidance to the topic.

__Continuous Integration__

The OSDU forum is responsible for Continuous Integration which involves running a suite of integration tests of application code but it is not responsible for Deployment.  Code that is merged into master branches would typically be integration tested fully.

This strategy comes with the following restrictions.  The microservices are tested against each other purely based on a point in time and there is no integration testing across services from a release concept.

The following diagram attempts to show how you a point in time can be taken across all the services and it can be known that all integration tests pass at the point in time but it is not known if Service A (Now) works with Service B or Service C (Past).

```
    [Infrastructure]         [Service A]             [Service B]
            |                     |                       |
            |                     |                       |
Now --------------------------------------------------------------
            |                     |                       |
            |                     |                       |
Past -------------------------------------------------------------
            |                     |                       |
            |                     |                       |
Past -------------------------------------------------------------

```

__Continuous Deployment__

Microsoft has a mechanism in place using Azure Devops Pipelines that enables the ability to continuously deploy OSDU on Azure or apply a _Continous Delivery_ concept with a staged gate approval check prior to deploy.

This method of deployment works well when the desire is to automatically move the timeline forward on the services and scheduled intervals.  These intervals can be manually triggered or automatically triggered based on a cron style schedule.  The timeline however can only be moved to a current `Now`.  It can not move to a specified point in the timeline or move backward.

This is helpful if the intent of deployment is one where the desire is to have an environment that tracks along directly with the OSDU forum master branches, perhaps for a development environment to make code changes and contribute back to the forum.

This method of deployment is not very helpful if the desire is to choose a release, install that release, update a release, or rollback a release.

__Release Deployment__

Microsoft has recently implemented a process under trial where a more typical release style install is possible that allows a specified point in time to be selected and installed and then potentially update to a new point in time or rollback to a previous point in time.


```
    [Infrastructure]         [Service A]             [Service B]
            |                     |                       |
            |                     |                       |
v3   -------------------------------------------------------------
            |                     |                       |
            |                     |                       |
v2   -------------------------------------------------------------
            |                     |                       |
            |                     |                       |
v1   -------------------------------------------------------------

```

This style of release process then must also be somewhat aligned with a development process that can then be sufficiently tracked in order to be able to tell what the delta changes are between a release marker.  Additionally, there starts to be a dependency tracking matrix then that must grow across infrastructure, middleware and services to be able to answer the following type of questions.

_Question:_ Can I update infrastructure v2 to v3 while running application code v2?

_Question:_ Can I run both application code v2 and v3 on infrastructure v3?

_Question:_ How do I manage infrastructure updates and possible breaking changes?


__Release Naming Strategy__

A release naming strategy needs to be in place with the OSDU forum and then can be extended for use by OSDU on Azure.  A typical naming convention that is helpful is some type of [Semantic Versioning](https://semver.org/).  Consider the following possible naming patterns.

`[Major]:[Minor]:[Patch]`

A naming pattern of this would require the OSDU forum to drop a release marker across the system and ensure that integration tests passed on the point in time timeline.  Patch however tends to lead to the idea that individual services are being bug fixed and not all services might have the same patch version.  This breaks the timeline model requirement of ensuring integration tests passed.

`[Horizon]:[Milestone]:[Iteration]`

A naming pattern might make sense based on the OSDU forum tracking to horizon's and milestones.  Additionally though is the concept of what might be thought of as an Developer Iteration release.

Example 1:
The OSDU forum drops a release marker of H1:M1:0.  This could indicate a release with a certain level of certification.

- Horizon _(All Providers)_
  - Integration Tests pass
  - Validation Scenarios pass
  - Certification Processes completed
- Milestone _(All Providers)_
  - Integration Tests pass
  - Validation Scenarios pass
- Iteration _(Single Provider specific)_
  - Integration Tests pass

The Iteration then can be aligned to developer releases that are faster moving but have less quality control checks applied and can be triggered or not triggered as desired by each cloud provider.

## OSDU on Azure Current Release Strategy

OSDU on Azure has been prototyping a release style mechanism since November 2020 and attempting to align a development process for infrastructure to this release strategy.

__Process: Project Roadmap__

Traditional style roadmaps are a hard thing to accomplish at this time due to the fluidity of the project.  The attempt in place is to give at least a picture of what is currently thought to be up next, commited and in work, and completed using a Kanban board.

As typical however in a development project over a sprint/iteration effort things will be added or removed depending upon the situations that occur.

- [Developer Board](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/boards)


__Process: Project Milestones__

Each month a Project Milestone is initiated that tracks the Issues/Bugs and Merge Requests planned and worked on.

- [January-21  Milestone](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/milestones/5)
- [December-20 Milestone](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/milestones/4)

__Process: Project Release__

Each month when a Project Milestone closes a release is dropped.  At this time the process to do this is entirely manual and the following tasks are completed.

- Identify latest passing OSDU Service Containers from the master branch for all services.
- Retag all community built container images identified to a semver pattern
- Push all newly tagged images to a Microsoft hosted Azure Container Registry.
- Update the infrastructure project [CHANGELOG.md](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/CHANGELOG.md)
- Drop a [release tag](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/tags/azure-0.4.3) to infrastructure project to version infrastructure.
- Update OSDU on Azure helm charts with the release and update [CHANGELOG.md](https://community.opengroup.org/osdu/platform/deployment-and-operations/helm-charts-azure/-/blob/master/CHANGELOG.md)
- [Document](https://community.opengroup.org/osdu/platform/deployment-and-operations/helm-charts-azure/-/blob/master/README.md#app-version-043-2021-1-25) the OSDU on Azure Helm Chart release and drop a [release tag](https://community.opengroup.org/osdu/platform/deployment-and-operations/helm-charts-azure/-/tags/azure-0.4.3).


__Installation: New__

Installations of OSDU on Azure can be completed end to end for a release and the process to do so would look something like the following.

> Directions often change and the directions here are to meant to only understand the intent of what a new installation process might look like.

1. Clone the Infrastructure Project and checkout the desired [release tag](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/tree/azure-0.4.3)

2. Setup any Prerequisites for OSDU on Azure following the [documented directions](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/azure-0.4.3/README.md#prerequisites).

2. Build the infrastructure following the [documented procedures](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/azure-0.4.3/README.md) on the project.

3. Install the required Istio Helm charts following the [documented procedures](https://community.opengroup.org/osdu/platform/deployment-and-operations/helm-charts-azure/-/blob/azure-0.4.3/osdu-istio/README.md)

4. Install the required Airflow Helm charts following the [documented procedures](https://community.opengroup.org/osdu/platform/deployment-and-operations/helm-charts-azure/-/blob/azure-0.4.3/osdu-airflow/README.md)

5. Install the required OSDU on Azure Application Helm charts following the [documented procedures](https://community.opengroup.org/osdu/platform/deployment-and-operations/helm-charts-azure/-/blob/azure-0.4.3/osdu-azure/README.md)


__Installation: Upgrade__

Upgrades of OSDU on Azure can be completed in different manners depending upon the desired situation.  This is meant to just give an example of the tasks that would be required to do a typical upgrade.

1. Simple Upgrades

- Update Infrastructure
- Update new released helm charts

2. Blue Green Upgrades

- Configure Azure Front Door to act as an entry point and direct traffic to `blue` or `green`
- Update Infrastructure
- Install release in `green` namespace
- Test and validate `green` release
- Redirect traffic to `green` release


# Additional Resources

Release management is an evolving idea and other links relating to release management should be consulted and understood as things evolve and change.

- [Azure Operating Procedures Wiki](https://community.opengroup.org/osdu/documentation/-/wikis/Azure-Operating-Procedures-for-OSDU#deployment-and-release-management)
- [OSDU Forum Release Strategy](https://community.opengroup.org/osdu/governance/project-management-committee/-/wikis/Release-Strategy)
- [OSDU Forum Tagging Notes](https://community.opengroup.org/osdu/governance/project-management-committee/-/wikis/Release-0.4-Tagging-Notes)
