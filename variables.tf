variable "namespace" {
  description = "Name of the Kubernetes namespace"
  default     = "translator"
}

variable "ui_deployment" {
  description = "Name of the UI deployment"
  default     = "translator-ui"
}

variable "back_deployment" {
  description = "Name of the backend deployment"
  default     = "translator-back"
}

variable "ui_port" {
  description = "Port of the UI application"
  default     = 5000
}

variable "back_port" {
  description = "Port of the backend application"
  default     = 8080
}

variable "yandex_token" {
  description = "Yandex token"
  default     = ""
}

variable "back_docker_image" {
  description = "Name of the backend docker image"
  default     = "translator"
}

variable "ui_docker_image" {
  description = "Name of the UI docker image"
  default     = "translator-ui"
}

variable "version_back_docker_image" {
  description = "Version of the backend docker image"
  default     = "v2"
}

variable "version_ui_docker_image" {
  description = "Version of the UI docker image"
  default     = "v2"
}
