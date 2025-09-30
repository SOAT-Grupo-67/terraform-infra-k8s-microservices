terraform {
  backend "s3" {
    bucket       = "hackathon-fiap-microservices-k8s"
    key          = "microservices-k8s/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}