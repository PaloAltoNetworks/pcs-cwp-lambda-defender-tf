variable "prisma_username" {
  type        = string
  description = "Name or ARN of the secret"
  sensitive   = true
}

variable "prisma_password" {
  type        = string
  description = "Region where the Secret is stored"
  sensitive   = true
}

variable "console_url" {
  type      = string
  sensitive = true
}

variable "console_san" {
  type      = string
  sensitive = true
  default   = ""
}

variable "runtime" {
  type        = string
  default     = "python"
  description = "Name of the AMI to be built"
}

variable "compatible_runtimes" {
  type    = list(string)
  default = ["python3.6", "python3.7", "python3.8", "python3.9", "python3.10", "python3.11", "python3.12"]
}

variable "layer_name" {
  type    = string
  default = "prismacloud_layer_python"
}

variable "layer_filename" {
  type    = string
  default = "twistlock_defender_layer.zip"
}

variable "function_name" {
  type        = string
  description = "Name of the function to be deployed"
}

variable "original_handler" {
  type    = string
  default = "lambda_function.lambda_handler"
}

variable "function_role" {
  type = string
}