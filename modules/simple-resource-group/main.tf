# modules/simple-resource-group/main.tf

# 이 모듈은 Azure 리소스 그룹 하나를 생성합니다.

resource "azurerm_resource_group" "example_rg" {
  name     = var.resource_group_name
  location = var.location
  tags = {
    ManagedBy = "TerraformModule"
    Purpose   = "VersionedDemo"
    ModuleVersion = var.module_version # 모듈 버전을 태그로 추가
    NewFeature    = "true" # 새로운 태그 추가
  }
}