locals {
  common_tags = {
    "Application"         = var.applicationTag
    "Environment "        = var.environmentTag
    "Consumer"            = var.consumerTag
    "MCSManageTag-Backup" = "Yes"
    "Division"            = var.divisionTag
    "DataClassification"  = var.dataclassificationTag
    "Costcenter"          = var.costcenterTag
    "Terraform-path"      = var.terraform-pathTag
    "repository"          = var.repository_urlTag
    "code_owner"          = var.code_ownerTag
    "code_maintainer"     = var.code_maintainerTag

  }
}