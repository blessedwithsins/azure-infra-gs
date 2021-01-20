provider "azurerm" {
  features {}
}

module "resource_group" {
  source = "../../resource-group"

  name     = "osdu-module"
  location = "eastus2"
}


module "cosmosdb_sql" {
  source     = "../"
  depends_on = [module.resource_group]

  name                = "osdu-module-sql-${module.resource_group.random}"
  resource_group_name = module.resource_group.name

  kind                     = "GlobalDocumentDB"
  automatic_failover       = true
  consistency_level        = "Session"
  primary_replica_location = module.resource_group.location

  databases = [
    {
      name       = "osdu-module-database"
      throughput = 4000 # This is max throughput Minimum level is 4000
    }
  ]
  sql_collections = [
    {
      name               = "osdu-module-container1"
      database_name      = "osdu-module-database"
      partition_key_path = "/id"

    },
    {
      name               = "osdu-module-container2"
      database_name      = "osdu-module-database"
      partition_key_path = "/id"
    }
  ]

  resource_tags = {
    source = "terraform",
  }
}

module "cosmosdb_graph" {
  source     = "../"
  depends_on = [module.resource_group]

  name                = "osdu-module-graph-${module.resource_group.random}"
  resource_group_name = module.resource_group.name

  kind                     = "GlobalDocumentDB"
  automatic_failover       = true
  consistency_level        = "Session"
  primary_replica_location = module.resource_group.location

  graph_databases = [
    {
      name       = "osdu-module-database"
      throughput = 4000 # This is max throughput Minimum level is 4000
    }
  ]

  graphs = [
    {
      name               = "osdu-module-graph1"
      database_name      = "osdu-module-database"
      partition_key_path = "/mypartition"
    },
    {
      name               = "osdu-module-graph2"
      database_name      = "osdu-module-database"
      partition_key_path = "/mypartition"
    }
  ]

  resource_tags = {
    source = "terraform",
  }
}
