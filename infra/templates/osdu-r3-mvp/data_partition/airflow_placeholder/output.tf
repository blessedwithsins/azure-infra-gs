output "kube_config" {
  sensitive = true
  value     = list({
    host = "",
    username = "",
    client_certificate = "",
    client_key = ""
    cluster_ca_certificate = ""
  })
}