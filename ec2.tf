resource "aws_instance" "kafka" {
  ami                     = var.ami_id != null ? var.ami_id : data.aws_ami.ubuntu.id
  instance_type           = var.instance_type
  key_name                = var.key_pair_name
  iam_instance_profile    = aws_iam_instance_profile.kafka.name
  disable_api_stop        = true # Important for stateful services like kafka
  disable_api_termination = true # Important for stateful services like kafka

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.kafka_eni.id
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.disk_size
    iops                  = var.disk_iops
    throughput            = var.disk_throughput
    encrypted             = var.encrypt_storage
    delete_on_termination = var.delete_storage_on_termination
  }

  depends_on = [
    aws_s3_bucket.kafka_assets,
    aws_s3_object.kafka_cloudwatch_script,
    aws_s3_object.cloudwatch_agent_config
  ]

  user_data = templatefile("${path.module}/files/userdata.sh.tftpl", {
    kafka_heap_opts             = var.kafka_heap_opts
    kafka_topics                = var.kafka_topic_config
    cloudwatch_config_s3_uri    = format("s3://%s/%s", aws_s3_bucket.kafka_assets.bucket, aws_s3_object.cloudwatch_agent_config.key)
    statsd_script_s3_uri        = format("s3://%s/%s", aws_s3_bucket.kafka_assets.bucket, aws_s3_object.kafka_cloudwatch_script.key)
    log_retention_bytes         = local.log_retention_bytes
    log_retention_hours         = local.log_retention_hours
    segment_bytes               = local.segment_bytes
    log_segment_delete_delay_ms = local.log_segment_delete_delay_ms
  })

  user_data_replace_on_change = false

  tags = merge(local.common_tags, {
    Name         = local.stack_identifier,
    ResourceType = "database"
  })
}
