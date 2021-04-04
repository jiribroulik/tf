variable "region" {
  default = ""
}

variable "ENVIRONMENT" {
  type    = string
  default = ""
}

variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)

  default = [
    "876283645480",
  ]
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      rolearn  = "arn:aws:iam::876283645480:role/TJFullAccessToDataScript"
      username = "TJFullAccessToDataScript"
      groups   = ["system:masters"]
    },
  ]
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      userarn  = "arn:aws:iam::876283645480:user/broulik"
      username = "broulik"
      groups   = ["system:masters"]
    },
  ]
}