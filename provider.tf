terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"  # Change this to your preferred region
}

provider "kubernetes" {
  config_path = "/home/scott/.kube/config" # Replace with your kubeconfig path
  #context = "your-context" #if needed
}

provider "kubectl" {
  config_path = "~/.kube/config"
}






