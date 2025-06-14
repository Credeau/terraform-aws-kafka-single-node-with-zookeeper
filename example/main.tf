module "kafka" {
  source = "git::https://github.com/credeau/terraform-aws-kafka-single-node-with-zookeeper.git?ref=v1.0.0"

  application                   = "mobile-forge"
  environment                   = "prod"
  region                        = "ap-south-1"
  stack_owner                   = "tech@credeau.com"
  stack_team                    = "devops"
  organization                  = "credeau"
  alert_email_recipients        = []
  vpc_id                        = "vpc-00000000000000000"
  subnet_id                     = "subnet-00000000000000000"
  kafka_whitelisted_cidrs       = ["52.52.0.0/16"]
  kafka_whitelisted_sg_ids      = ["sg-00000000000000000"]
  ssh_whitelisted_cidrs         = []
  ssh_whitelisted_sg_ids        = []
  instance_type                 = "t3a.medium"
  key_pair_name                 = "mobile-forge-demo"
  ami_id                        = null
  cpu_threshold                 = 70
  memory_threshold              = 70
  disk_threshold                = 70
  disk_size                     = 50
  disk_iops                     = 3000
  disk_throughput               = 125
  encrypt_storage               = true
  delete_storage_on_termination = true
  kafka_heap_opts               = "-Xms1024m -Xmx1024m"
  kafka_topic_config = {
    "sms_batched"             = 20
    "apps_and_device_batched" = 10
    "contacts_batched"        = 5
    "call_logs_batched"       = 5
    "events_log"              = 20
    "dev_things"              = 5
  }
  kafka_log_retention_hours = 2
}