**Release name**: `INSERT OSDU RELEASE NAME HERE`

The following steps must be completed OSDU Azure release.

For more information, visit our release documentation [here](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/CHANGELOG.md).

## Steps:

**Infra Board closure**
- [ ] Mark all issues closed which have been completed in the release. [Link](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/boards). Note that creating an issue ticket as "Close Release - <version>" helps as a mark up for the release

**Deploy terraform scripts**
- [ ] Central Resources
- [ ] Service Resources
- [ ] Data Paritions.

**Create service release images**
- [ ] Upload release service images to ACR.
- [ ] Create and Update service charts
- [ ] Upload service charts to ACR.

**Create Data seeding**
- [ ] Update documentation for following seeding data, Config, Manifest DAG, CSV Parser DAG, Schema, Entitlements, Policy, ZGY DAG and VDS DAG.
- [ ] Create and Upload versioned image for following seeding data, Config, Manifest DAG, CSV Parser DAG, Schema, Entitlements, Policy, ZGY DAG and VDS DAG.
- [ ] Update scripts for data seeding.

**Upload Data prior to service deployment**
- [ ] Upload Config Data
- [ ] Upload Manifest Ingest DAG

**Service deployment**
- [ ] Partition Service
- [ ] Security Services
- [ ] Core Services
- [ ] Reference Services
- [ ] Ingest Services
- [ ] Seismic Services
- [ ] Wellbore Services

**Upload Data post to service deployment**
- [ ] Upload Entitlements Data
- [ ] Upload Schema
- [ ] Upload Policies
- [ ] Upload CSV Parser DAG
- [ ] Upload SEGY to ZGY DAG Conversion
- [ ] Upload SEGY to VDS DAG Conversion

**Validation**
Test services and dags using REST scripts[Link](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/tree/master/tools/rest).
- [ ] Test services
- [ ] Test Manifest DAG
- [ ] Test CSV DAG
- [ ] Test ZGY DAG
- [ ] Test VDS DAG

