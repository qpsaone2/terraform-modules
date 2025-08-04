# modules/virtual-machine/variables.tf

# 모듈의 입력 변수들을 정의합니다.
variable "resource_group_name" {
  description = "VM이 생성될 기존 리소스 그룹의 이름"
  type        = string
}

variable "location" {
  description = "VM이 생성될 Azure 지역"
  type        = string
}

variable "vm_name" {
  description = "생성할 가상 머신의 이름"
  type        = string
}

variable "vm_size" {
  description = "가상 머신의 크기 (예: Standard_B1s)"
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "VM 관리자 사용자 이름"
  type        = string
}

variable "public_ssh_key_path" {
  description = "VM에 주입할 SSH 공개 키 파일의 로컬 경로"
  type        = string
}

variable "web_server_port" {
  description = "웹 서버가 리스닝할 포트"
  type        = number
  default     = 80
}

variable "environment" {
  description = "배포 환경 (예: dev, stage, prod)"
  type        = string
}

variable "module_version" {
  description = "모듈의 현재 버전 (리소스 태그 및 user_data에 사용)"
  type        = string
}