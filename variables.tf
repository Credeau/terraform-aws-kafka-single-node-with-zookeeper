# ----------------------------------------------
# Deployment Environment Related Variables
# ----------------------------------------------
variable "application" {
  type        = string
  description = "Application name for which this database is provisioned"
  default     = "dummy"
}

variable "environment" {
  type        = string
  description = "Provisioning environment"
  default     = "dev"

  validation {
    condition     = contains(["dev", "prod", "br"], var.environment)
    error_message = "Environment must be one of: dev, prod, or br."
  }
}

variable "region" {
  type        = string
  description = "AWS operational region"
  default     = "ap-south-1"
}

variable "stack_owner" {
  type        = string
  description = "owner of the stack"
  default     = "tech@credeau.com"
}

variable "stack_team" {
  type        = string
  description = "team of the stack"
  default     = "devops"
}

variable "organization" {
  type        = string
  description = "organization name"
  default     = "credeau"
}

variable "alert_email_recipients" {
  type        = list(string)
  description = "email recipients for sns alerts"
  default     = []
}

# ----------------------------------------------
# Network Related Variables
# ----------------------------------------------

variable "vpc_id" {
  type        = string
  description = "VPC ID of the VPC to provision the resources in"
}

variable "private_subnet_id" {
  type        = string
  description = "VPC Subnet ID to launch the server network"
}

variable "kafka_whitelisted_cidrs" {
  type        = list(string)
  description = "List of CIDR block IP ranges to allow connecting with Kafka (port: 9092)"
  default     = []
}

variable "kafka_whitelisted_sg_ids" {
  type        = list(string)
  description = "List of Security Group IDs to allow connecting with Kafka (port: 9092)"
  default     = []
}

variable "ssh_whitelisted_cidrs" {
  type        = list(string)
  description = "List of CIDR block IP ranges to allow SSH on Kafka instance (port: 22)"
  default     = []
}

variable "ssh_whitelisted_sg_ids" {
  type        = list(string)
  description = "List of Security Group IDs to allow SSH on Kafka instance (port: 22)"
  default     = []
}

# ----------------------------------------------
# Server Related Variables
# ----------------------------------------------

variable "instance_type" {
  type        = string
  description = "Type of instance to provision for Kafka"
  default     = "t3a.large"
}

variable "key_pair_name" {
  type        = string
  description = "SSH key pair to use for system access"
}

variable "ami_id" {
  type        = string
  description = "AMI ID to use for Kafka (if not specified latest ubuntu 22.04 image is used)"
  default     = null
}

variable "cpu_threshold" {
  type        = number
  description = "CPU usage threshold for alerts"
  default     = 60
}

variable "memory_threshold" {
  type        = number
  description = "Memory usage threshold for alerts"
  default     = 60
}

variable "disk_threshold" {
  type        = number
  description = "Disk usage threshold for alerts"
  default     = 60
}

# ----------------------------------------------
# Storage Related Variables
# ----------------------------------------------

variable "disk_size" {
  type        = number
  description = "Size in GBs to provision as kafka storage"
  default     = 25

  validation {
    condition     = var.disk_size >= 1 && var.disk_size <= 16384
    error_message = "The disk_size value for a GP3 disk must be between 1 and 16384 GBs."
  }
}

variable "disk_iops" {
  type        = number
  description = "IOPS to provision in Kafka storage"
  default     = 3000

  validation {
    condition     = var.disk_iops >= 3000 && var.disk_iops <= 16000
    error_message = "The disk_iops value for a GP3 disk must be between 3000 and 16000."
  }
}

variable "disk_throughput" {
  type        = number
  description = "Throughput to provision in Kafka storage"
  default     = 250

  validation {
    condition     = var.disk_throughput >= 250 && var.disk_throughput <= 1000
    error_message = "The disk_throughput value for a GP3 disk must be between 250 and 1000."
  }
}

variable "encrypt_storage" {
  type        = bool
  description = "Enable/Disable the encryption of Kafka storage"
  default     = false
}

variable "delete_storage_on_termination" {
  type        = bool
  description = "Enable/Disable the deletion of Kafka storage on instance termination"
  default     = true
}

# ----------------------------------------------
# Kafka Related Variables
# ----------------------------------------------

variable "kafka_heap_opts" {
  type        = string
  description = "Heap options for Kafka"
  default     = "-Xms2G -Xmx2G"
}

variable "kafka_topic_config" {
  type = map(number)
  default = {
    "sms_batched"             = 1
    "apps_and_device_batched" = 1
    "contacts_batched"        = 1
    "call_logs_batched"       = 1
    "events_log"              = 1
    "dev_things"              = 1
  }
  description = "Map of Kafka topics and their partition counts"
}

variable "kafka_log_retention_hours" {
  type        = number
  description = "Log retention hours for Kafka"
  default     = null

  validation {
    condition     = var.kafka_log_retention_hours == null ? true : (var.kafka_log_retention_hours >= 1 && var.kafka_log_retention_hours <= 168)
    error_message = "The kafka_log_retention_hours value must be between 1 and 168."
  }
}

variable "kafka_log_retention_bytes" {
  type        = number
  description = "Log retention bytes for Kafka"
  default     = null

  validation {
    condition     = var.kafka_log_retention_bytes == null ? true : (var.kafka_log_retention_bytes >= 134217728 && var.kafka_log_retention_bytes <= 10737418240)
    error_message = "The kafka_log_retention_bytes value must be between 128 MB (134217728) and 10GB (10737418240)."
  }
}

variable "kafka_segment_bytes" {
  type        = number
  description = "Segment bytes for Kafka"
  default     = null

  validation {
    condition     = var.kafka_segment_bytes == null ? true : (var.kafka_segment_bytes >= 134217728 && var.kafka_segment_bytes <= 1073741824)
    error_message = "The kafka_segment_bytes value must be between 128MB (134217728) and 1GB (1073741824)."
  }
}

variable "kafka_log_segment_delete_delay_ms" {
  type        = number
  description = "Log segment delete delay for Kafka"
  default     = null

  validation {
    condition     = var.kafka_log_segment_delete_delay_ms == null ? true : (var.kafka_log_segment_delete_delay_ms >= 0 && var.kafka_log_segment_delete_delay_ms <= 300000)
    error_message = "The kafka_log_segment_delete_delay_ms value must be between 0 and 300000."
  }
}

