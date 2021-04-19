[[_TOC_]]
## Introdcution
There are two categories of such dependency where actual data is written at one place and reference or metadata is created somewhere else-
1- Data in DMS and metadata in storage service
2- Data in Blob store and metadata in cosmos db.

One round of scrutiny of R2/ R3 services has been done and here is how it looks-

## Services which talk to both Storage service and DDMS

| Service | Storage service dependency  | DMS dependency | Handled correctly | Reference file|
|--|--|--|--|--|
| File | Yes | Yes | Yes | [FileMetadataService.java](https://community.opengroup.org/osdu/platform/system/file/-/blob/master/file-core/src/main/java/org/opengroup/osdu/file/service/FileMetadataService.java#L65)
| Indexer | Yes | No | NA | NA |
| WKS | Yes | No | NA | NA |

## Services which talk to both BlobStore and Cosmos DB


|Service | Cosmos dependency | BlobStore dependency | interdependency between blob and cosmos db | Handled correct | Reference file |
|--|--|--|--|--|--|
| File | Yes | Yes | No | NA | NA |
| Storage | Yes | Yes | Yes | Yes  | [PersistenceServiceImpl.java](https://community.opengroup.org/osdu/platform/system/storage/-/blob/master/storage-core/src/main/java/org/opengroup/osdu/storage/service/PersistenceServiceImpl.java#L77) |
| Schema | Yes | Yes | Yes | Yes | [SchemaService.java](https://community.opengroup.org/osdu/platform/system/schema-service/-/blob/master/schema-core/src/main/java/org/opengroup/osdu/schema/service/serviceimpl/SchemaService.java#L148) |
| WKS | Yes | Yes | No | NA | NA |
| Legal | Yes | Yes | No | NA  | NA |
| Ingestion Workflow | Yes | Yes | No | NA | NA |


## Conclusion
Overall, wherever there is data written in such fashion, the idempotency is ensured. If data write at one place fails, we do necessary cleanup from the other place too.




