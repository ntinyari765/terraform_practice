terraform {
  cloud {
    organization = "ntinyari-terraform"
    workspaces {
      name = "webserver-cluster-dev"
    }
  }
}