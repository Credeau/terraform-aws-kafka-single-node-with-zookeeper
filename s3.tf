resource "random_string" "suffix" {
  length  = 6
  upper   = false
  lower   = true
  numeric = true
  special = false
}

resource "aws_s3_bucket" "kafka_assets" {
  bucket        = format("%s-assets-%s", local.stack_identifier, random_string.suffix.result)
  force_destroy = true

  tags = merge(local.common_tags, {
    Name         = format("%s-assets", local.stack_identifier),
    ResourceType = "storage"
  })
}

resource "aws_s3_bucket_public_access_block" "kafka_assets" {
  bucket = aws_s3_bucket.kafka_assets.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "kafka_cloudwatch_script" {
  bucket       = aws_s3_bucket.kafka_assets.id
  key          = "scripts/metrics_statsd.py"
  source       = "${path.module}/python/metrics_statsd.py"
  content_type = "text/x-python"
  etag         = filemd5("${path.module}/python/metrics_statsd.py")
}

resource "aws_s3_object" "cloudwatch_agent_config" {
  bucket = aws_s3_bucket.kafka_assets.id
  key    = "config/cwa_config.json"

  content = templatefile("${path.module}/configs/cwa_config.json", {
    application_identifier = local.stack_identifier
  })

  content_type = "text/plain"
  etag         = filemd5("${path.module}/configs/cwa_config.json")
}

resource "aws_s3_object" "kafka_service" {
  bucket = aws_s3_bucket.kafka_assets.id
  key    = "config/kafka.service"

  content = templatefile("${path.module}/configs/kafka.service", {
    kafka_heap_opts             = var.kafka_heap_opts
    log_retention_hours         = local.log_retention_hours
    log_retention_bytes         = local.log_retention_bytes
    segment_bytes               = local.segment_bytes
    log_segment_delete_delay_ms = local.log_segment_delete_delay_ms
  })

  content_type = "text/plain"
  etag         = filemd5("${path.module}/configs/kafka.service")
}

resource "aws_s3_object" "zookeeper_service" {
  bucket       = aws_s3_bucket.kafka_assets.id
  key          = "config/zookeeper.service"
  source       = "${path.module}/configs/zookeeper.service"
  content_type = "text/plain"
  etag         = filemd5("${path.module}/configs/zookeeper.service")
}
