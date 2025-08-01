# modules/simple-resource-group/variables.tf

# 모듈의 입력 변수들을 정의합니다.
variable "resource_group_name" {
  description = "생성할 리소스 그룹의 이름"
  type        = string
}

variable "location" {
  description = "리소스 그룹이 생성될 Azure 지역"
  type        = string
}

variable "module_version" {
  description = "모듈의 현재 버전 (태그로 사용)"
  type        = string
}