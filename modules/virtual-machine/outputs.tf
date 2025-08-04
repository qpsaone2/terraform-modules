# modules/virtual-machine/outputs.tf

# 모듈의 출력 값들을 정의합니다.
output "vm_public_ip_address" {
  description = "생성된 VM의 Public IP 주소"
  value       = azurerm_public_ip.vm_public_ip.ip_address
}

output "vm_private_ip_address" {
  description = "생성된 VM의 Private IP 주소"
  value       = azurerm_network_interface.vm_nic.private_ip_address
}

output "vm_id" {
  description = "생성된 VM의 ID"
  value       = azurerm_linux_virtual_machine.single_vm.id
}

output "vm_name" {
  description = "생성된 VM의 이름"
  value       = azurerm_linux_virtual_machine.single_vm.name
}