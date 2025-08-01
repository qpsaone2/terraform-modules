# modules/simple-resource-group/outputs.tf

# 모듈의 출력 값들을 정의합니다.
output "created_resource_group_id" {
  description = "생성된 리소스 그룹의 ID"
  value       = azurerm_resource_group.example_rg.id
}

output "created_resource_group_name" {
  description = "생성된 리소스 그룹의 이름"
  value       = azurerm_resource_group.example_rg.name
}

output "created_resource_group_location" {
  description = "생성된 리소스 그룹의 위치"
  value       = azurerm_resource_group.example_rg.location
}