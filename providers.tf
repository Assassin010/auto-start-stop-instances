########## REGION OF DEPLOYMENT ##########
provider "aws" {
  profile = "mat_user"
  assume_role {
    role_arn     = "arn:aws:iam::339085260722:role/matfdna-matillion-cf-role-new"
    session_name = "Gauthier_Kwatatshey"
  }
  region = var.aws_region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.30.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.3.0"
    }

    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }

  required_version = "~> 1.0"
}
