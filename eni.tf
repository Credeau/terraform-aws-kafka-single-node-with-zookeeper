resource "aws_network_interface" "kafka_eni" {
  subnet_id       = var.subnet_id
  security_groups = [aws_security_group.kafka.id]

  tags = merge(local.common_tags, {
    Name         = format("%s-eni", local.stack_identifier),
    ResourceType = "network"
  })
}
