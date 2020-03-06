variable "project" {
  default = "turing-reach-254009"
}

variable "region" {
  default = "europe-north1-a"
}

variable "default_user" {
  default = "appuser"
}

#===============================================
# Count of PVE servers
#===============================================
variable "count_instance" {
  default = "0"
}

variable "zone_instance" {
  default = "europe-north1-a"
}

variable "disk_image" {
  default = "ubuntu-1804-lts"
}

variable "zabbix_tag" {
  default = "zabbix-app"
}
