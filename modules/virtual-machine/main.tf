# modules/virtual-machine/main.tf

# 이 모듈은 기존 리소스 그룹 안에 단일 Azure VM을 프로비저닝합니다.

# 1. 가상 네트워크 및 서브넷 생성
resource "azurerm_virtual_network" "vm_vnet" {
  name                = "${var.vm_name}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name # 기존 RG 이름 사용
  tags = {
    ManagedBy     = "TerraformModule"
    ModuleVersion = var.module_version
  }
}

resource "azurerm_subnet" "vm_subnet" {
  name                 = "${var.vm_name}-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vm_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# 2. Public IP 주소 생성
resource "azurerm_public_ip" "vm_public_ip" {
  name                = "${var.vm_name}-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = {
    ManagedBy     = "TerraformModule"
    ModuleVersion = var.module_version
  }
}

# 3. 네트워크 보안 그룹 (NSG) 생성
resource "azurerm_network_security_group" "vm_nsg" {
  name                = "${var.vm_name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags = {
    ManagedBy     = "TerraformModule"
    ModuleVersion = var.module_version
  }
}

# 4. NSG 규칙: SSH (22번 포트) 허용
resource "azurerm_network_security_rule" "allow_ssh" {
  name                        = "AllowSSH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.vm_nsg.name
}

# 5. NSG 규칙: HTTP (80번 포트) 허용
resource "azurerm_network_security_rule" "allow_http" {
  name                        = "AllowHTTP"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.vm_nsg.name
}

# 6. 네트워크 인터페이스 생성
resource "azurerm_network_interface" "vm_nic" {
  name                = "${var.vm_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags = {
    ManagedBy     = "TerraformModule"
    ModuleVersion = var.module_version
  }

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_public_ip.id
  }
}

# 7. NSG를 네트워크 인터페이스에 연결
resource "azurerm_network_interface_security_group_association" "nic_nsg_association" {
  network_interface_id        = azurerm_network_interface.vm_nic.id
  network_security_group_id = azurerm_network_security_group.vm_nsg.id
}

# 8. Linux 가상 머신 생성
resource "azurerm_linux_virtual_machine" "single_vm" {
  name                            = var.vm_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  admin_ssh_key {
    username = var.admin_username
    public_key = file(var.public_ssh_key_path) # SSH 공개 키 파일 경로
  }
  network_interface_ids           = [azurerm_network_interface.vm_nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  # user data 스크립트에 동적 데이터 주입 (templatefile 함수 사용)
  user_data = base64encode(templatefile("${path.module}/user-data.sh.tpl", {
    vm_name        = var.vm_name
    web_server_port = var.web_server_port
    module_version  = var.module_version # 모듈 버전을 스크립트에 주입
  }))

  tags = {
    Environment   = var.environment
    Project       = "SingleVM"
    ModuleVersion = var.module_version # VM에도 모듈 버전을 태그로 추가
  }
}