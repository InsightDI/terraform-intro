resource "azurerm_storage_account" "intro" {
  name                     = substr(lower(format("%s%s", var.prefix, "demostor")), 0, 24)
  location                 = var.location
  resource_group_name      = var.resource_group_name
  account_tier             = "Standard"
  account_replication_type = "LRS"

  allow_blob_public_access = true

  static_website {
    index_document = "index.html"
  }
}

resource "azurerm_storage_blob" "intro" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.intro.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source                 = "web/index.html"
}