variable "number" {
   default = 3
}
resource "azurerm_resource_group" "nomad" {
  name     = "nomad"
  location = "West US 2"
}

resource "azurerm_public_ip" "nomad" {
  count = "${var.number}"
  name                         = "nomadip-${count.index}"
  location                     = "${azurerm_resource_group.nomad.location}"
  resource_group_name          = "${azurerm_resource_group.nomad.name}"
  public_ip_address_allocation = "static"


}


resource "azurerm_virtual_network" "nomad" {
  name                = "acctvn"
  address_space       = ["10.0.0.0/16"]
  location            = "West US 2"
  resource_group_name = "${azurerm_resource_group.nomad.name}"
}

resource "azurerm_subnet" "nomad" {
  name                 = "acctsub"
  resource_group_name  = "${azurerm_resource_group.nomad.name}"
  virtual_network_name = "${azurerm_virtual_network.nomad.name}"
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_network_interface" "nomad" {
  count = "${var.number}"
  name                = "nomad-ni-${count.index}"
  location            = "West US 2"
  resource_group_name = "${azurerm_resource_group.nomad.name}"

  ip_configuration {
    name                          = "nomadconfiguration1"
    subnet_id                     = "${azurerm_subnet.nomad.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id =  "${element(azurerm_public_ip.nomad.*.id, count.index)}"
  }
}

resource "azurerm_virtual_machine" "nomad" {
  count = "${var.number}"
  name                  = "nomad-${count.index}"
  location              = "West US 2"
  resource_group_name   = "${azurerm_resource_group.nomad.name}"
  network_interface_ids =  ["${element(azurerm_network_interface.nomad.*.id, count.index)}"]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "14.04.2-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk1-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  # Optional data disks
  storage_data_disk {
    name              = "datadisk_new-${count.index}"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "10"
  }

  os_profile {
    computer_name  = "nomad-${count.index}"
    admin_username = "ubuntu"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
      ssh_keys {
        path = "/home/ubuntu/.ssh/authorized_keys"
        key_data = "${file(pathexpand("~/.ssh/id_rsa.pub"))}"
      }
  }

  tags {
    environment = "staging"
  }
}
