# ------------------------------------------------
# 📡 Network & Connectivity
# ------------------------------------------------

# The resolved IP address of the Kafka instance (public or private based on setup)
output "host_address" {
  value = aws_network_interface.kafka_eni.private_ip
}

# ------------------------------------------------
# 📛 Identifiers & Metadata
# ------------------------------------------------

# Common application-specific identifier used for tagging and metric grouping
output "application_identifier" {
  value = local.common_name
}

# Availability zone in which the Kafka resources are deployed
output "availability_zone" {
  value = data.aws_subnet.main.availability_zone
}

# AMI ID of the Ubuntu image used for Kafka instance
output "ami_id" {
  value = var.ami_id != null ? var.ami_id : data.aws_ami.ubuntu.id
}

# Bucket on which the Kafka bootstrap assets are uploaded
output "assets_bucket" {
  value = aws_s3_bucket.kafka_assets.bucket
}

# ------------------------------------------------
# 🔐 Security & Access
# ------------------------------------------------

# IAM role ARN attached to the Kafka instances
output "iam_role_arn" {
  value = aws_iam_role.main.arn
}

# Security group ID attached to the Kafka instance
output "security_group_id" {
  value = aws_security_group.kafka.id
}

# ------------------------------------------------
# 🧱 Instance Details
# ------------------------------------------------

# EC2 instance ID for the Kafka host
output "instance_id" {
  value = aws_instance.kafka.id
}
