variable "startup_script" {
    type = string
}
variable "cluster_name" {}
variable "region" {}
variable "project" {}
variable "isito_version" {}
variable "helm_version" {}
variable "calico_version" {}
variable "bastion_hostname" {}
variable "bastion_machine_type" {}
variable "bastion_tags" {
    type = list
}
variable "network" {}
