#vm instance count
variable "web_linux_vm_instance_count" {
  type = map(string)
  default = {
    "vm1" = "1022",
    "vm2" = "2022"
  }
}