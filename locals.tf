locals {
  common_tags = {
    Stage    = var.environment
    Owner    = var.stack_owner
    Team     = var.stack_team
    Pipeline = var.application
    Org      = var.organization
  }

  stack_identifier = format("%s-kafka-%s", var.application, var.environment)

  # -----------------------------------------------
  # Kafka Storage Configurations
  # -----------------------------------------------
  # % of disk to use for kafka log retention (80%)
  disk_threshold    = 0.7
  volume_size_bytes = var.disk_size * 1024 * 1024 * 1024 # Convert GB to bytes
  total_partitions  = sum(values(var.kafka_topic_config))

  # Calculate log retention bytes
  # If kafka_log_retention_bytes is not set, calculate it based on the total partitions
  log_retention_bytes = var.kafka_log_retention_bytes == null ? (local.total_partitions > 0 ? floor((local.volume_size_bytes * local.disk_threshold) / local.total_partitions) : 1073741824) : var.kafka_log_retention_bytes

  # Calculate log retention hours
  # If kafka_log_retention_hours is not set, set it to 2
  log_retention_hours = var.kafka_log_retention_hours == null ? 2 : var.kafka_log_retention_hours

  # Calculate segment bytes
  # If kafka_segment_bytes is not set, set it to 128MB
  segment_bytes = var.kafka_segment_bytes == null ? 134217728 : var.kafka_segment_bytes

  # Calculate log segment delete delay ms
  # If kafka_log_segment_delete_delay_ms delay ms is not set, set it to 30 seconds
  log_segment_delete_delay_ms = var.kafka_log_segment_delete_delay_ms == null ? 30000 : var.kafka_log_segment_delete_delay_ms
}
