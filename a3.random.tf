#random string
###name of the storage account should be unique
resource "random_string" "random" {
  length  = 6
  upper   = false
  special = false
}