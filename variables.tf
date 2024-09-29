variable "instance_type" {}
variable "name" {}
variable "env" {}
variable "port_no" {}
variable "ssh_pwd" {}
variable "vault_token" {}
variable "prometheus_node" {}
variable "iam_role" {
  default = "b58-iam-admin"
}
