variable "prisma_username" {
  type        = string
  sensitive   = true
  description = "Access Key of the Service Account to be used"
}

variable "prisma_password" {
  type        = string
  sensitive   = true
  description = "Secret Key of the Service Account to be used"
}

variable "console_url" {
  type        = string
  sensitive   = true
  description = "Prisma Cloud Compute console URL. Can be found in Prisma Cloud under Runtime Security > Manage > System > Utilities > Path to the Console"
}

variable "console_san" {
  type        = string
  sensitive   = true
  default     = ""
  description = "Prisma Cloud Compute console FQDN. If blank will be obtained from the console_url variable"
}

variable "runtime" {
  type        = string
  default     = "python"
  description = "Runtime of the Serverless Function. Only supported for python, nodejs and ruby"

  validation {
    condition     = contains(["python", "nodejs", "ruby"], var.runtime)
    error_message = "Valid values for runtime are (python, nodejs, ruby)"
  }
}

variable "runtime_version" {
  type        = string
  default     = "3.12"
  description = "Runtime version of the Serverless Function"

  validation {
    condition     = var.runtime == "python" && contains(["3.12", "3.11", "3.10", "3.9"], var.runtime_version) || var.runtime == "nodejs" && contains(["20.x", "18.x", "16.x"], var.runtime_version) || var.runtime == "ruby" && contains(["3.3", "3.2"], var.runtime_version)
    error_message = "Please choose a valid Runtime version. Supported versions: https://docs.prismacloud.io/en/enterprise-edition/content-collections/runtime-security/install/system-requirements#undefined"
  }
}

variable "module_type" {
  type        = string
  default     = ""
  description = "Type of module for NodeJS functions. Leave it blank for non NodeJS functions"

  validation {
    condition     = var.runtime == "nodejs" && contains(["ecmascript", "commonjs"], var.module_type) || var.runtime != "nodejs" && var.module_type == ""
    error_message = "Variable module_type is not correctly"
  }

}

variable "compatible_runtimes" {
  type        = list(string)
  default     = ["python3.9", "python3.10", "python3.11", "python3.12"]
  description = "list of Runtimes that the Defender Layer is compatible with"
}

variable "layer_name" {
  type        = string
  default     = "prismacloud_layer_python"
  description = "Prisma Cloud Defender Layer name"
}

variable "layer_filename" {
  type        = string
  default     = "twistlock_defender_layer.zip"
  description = "Name of the zip that contains the Prisma Cloud Defender Layer"
}

variable "function_name" {
  type        = string
  description = "Name of the function to be deployed"
}

variable "original_handler" {
  type        = string
  default     = "lambda_function.lambda_handler"
  description = "Handler of the original function"
}

variable "function_role" {
  type        = string
  description = "Role ARN to be used by the function"
}