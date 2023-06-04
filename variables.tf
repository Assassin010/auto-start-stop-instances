############ Input variable definitions ############
variable "aws_region" {
  description = "AWS region for all resources."
  type        = string
}

variable "create_trail" {
  description = "Set to false if a Cloudtrail trail for management events exists"
  type        = bool
}

variable "function_name1" {
  description = "Name of lambda function for stoping the instance"
  type        = string
}

variable "function_name2" {
  description = "Name of lambda function for starting the instance"
  type        = string
}

variable "lambda_log_level" {
  description = "Lambda logging level"
  type        = string
}

######### BACKEND  ########

variable "bucket_name" {
  description = "Backend for auto start stop"
  type        = string
}

######### STATE LOCK #######

variable "dynamodb_table_name" {
  description = "remote state lock"
  type        = string
}

########################
#  Define tags variables #
########################


variable "environmentTag" {
  description = "Envronment Tag to be applied on all resources. Valid values are Development, Test, Production and POC for the LAB accounts."
  type        = string

  validation {
    condition     = contains(["Development", "Test", "Production", "POC"], var.environmentTag)
    error_message = "Value must be on one of the following [Development,Test,Production,POC]."
  }
}

variable "applicationTag" {
  description = "Application CI name Tag to be applied on all resources. Must be valid CI name."
  type        = string
  default     = "dbtfdna"
}

variable "divisionTag" {
  description = "Division name Tag to be applied on all resources."
  type        = string
  default     = "CTO Org"
}

variable "consumerTag" {
  description = "Consumer and contact point email to be added to all resources."
  type        = string
  default     = null
}

variable "costcenterTag" {
  description = "Valid constcenter number for the billing of all project resources."
  type        = string
}

variable "code_ownerTag" {
  type = string
}

variable "code_maintainerTag" {
  type = string
}

variable "repository_urlTag" {
  type = string
}

variable "dataclassificationTag" {
  description = "This tag represents the classification of the Data that will reside in the resources. Accepted values are Public, Proprietary, Confidential and Sensitive."
  type        = string

  validation {
    condition     = contains(["Public", "Proprietary", "Confidential", "Sensitive"], var.dataclassificationTag)
    error_message = "Value must be on one of the following: Public, Proprietary, Confidential or Sensitive."
  }
}

variable "env_name" {
  type        = string
  description = "The environement name. Valid values are dev | sit | uat | prd."

  validation {
    condition     = contains(["dev", "sit", "uat", "prd"], var.env_name)
    error_message = "Valid values for environment are [dev, sit, uat, prd]."
  }
}
