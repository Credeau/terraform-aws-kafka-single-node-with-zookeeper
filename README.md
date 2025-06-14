<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0, < 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.kafka](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.kafka](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.ssh_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.kafka](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_network_interface.kafka_eni](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface) | resource |
| [aws_s3_bucket.kafka_assets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_public_access_block.kafka_assets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_object.cloudwatch_agent_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_s3_object.kafka_cloudwatch_script](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_s3_object.kafka_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_s3_object.zookeeper_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_security_group.kafka](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_sns_topic.alert_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.email_subscriptions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [random_string.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_subnet.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alert_email_recipients"></a> [alert\_email\_recipients](#input\_alert\_email\_recipients) | email recipients for sns alerts | `list(string)` | `[]` | no |
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | AMI ID to use for Kafka (if not specified latest ubuntu 22.04 image is used) | `string` | `null` | no |
| <a name="input_application"></a> [application](#input\_application) | Application name for which this database is provisioned | `string` | `"dummy"` | no |
| <a name="input_delete_storage_on_termination"></a> [delete\_storage\_on\_termination](#input\_delete\_storage\_on\_termination) | Enable/Disable the deletion of Kafka storage on instance termination | `bool` | `true` | no |
| <a name="input_disk_iops"></a> [disk\_iops](#input\_disk\_iops) | IOPS to provision in Kafka storage | `number` | `3000` | no |
| <a name="input_disk_size"></a> [disk\_size](#input\_disk\_size) | Size in GBs to provision as kafka storage | `number` | `25` | no |
| <a name="input_disk_throughput"></a> [disk\_throughput](#input\_disk\_throughput) | Throughput to provision in Kafka storage | `number` | `250` | no |
| <a name="input_encrypt_storage"></a> [encrypt\_storage](#input\_encrypt\_storage) | Enable/Disable the encryption of Kafka storage | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Provisioning environment | `string` | `"dev"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Type of instance to provision for Kafka | `string` | `"t3a.large"` | no |
| <a name="input_kafka_heap_opts"></a> [kafka\_heap\_opts](#input\_kafka\_heap\_opts) | Heap options for Kafka | `string` | `"-Xms2G -Xmx2G"` | no |
| <a name="input_kafka_log_retention_bytes"></a> [kafka\_log\_retention\_bytes](#input\_kafka\_log\_retention\_bytes) | Log retention bytes for Kafka | `number` | `null` | no |
| <a name="input_kafka_log_retention_hours"></a> [kafka\_log\_retention\_hours](#input\_kafka\_log\_retention\_hours) | Log retention hours for Kafka | `number` | `null` | no |
| <a name="input_kafka_log_segment_delete_delay_ms"></a> [kafka\_log\_segment\_delete\_delay\_ms](#input\_kafka\_log\_segment\_delete\_delay\_ms) | Log segment delete delay for Kafka | `number` | `null` | no |
| <a name="input_kafka_segment_bytes"></a> [kafka\_segment\_bytes](#input\_kafka\_segment\_bytes) | Segment bytes for Kafka | `number` | `null` | no |
| <a name="input_kafka_topic_config"></a> [kafka\_topic\_config](#input\_kafka\_topic\_config) | Map of Kafka topics and their partition counts | `map(number)` | <pre>{<br>  "apps_and_device_batched": 1,<br>  "call_logs_batched": 1,<br>  "contacts_batched": 1,<br>  "dev_things": 1,<br>  "events_log": 1,<br>  "sms_batched": 1<br>}</pre> | no |
| <a name="input_kafka_whitelisted_cidrs"></a> [kafka\_whitelisted\_cidrs](#input\_kafka\_whitelisted\_cidrs) | List of CIDR block IP ranges to allow connecting with Kafka (port: 9092) | `list(string)` | `[]` | no |
| <a name="input_kafka_whitelisted_sg_ids"></a> [kafka\_whitelisted\_sg\_ids](#input\_kafka\_whitelisted\_sg\_ids) | List of Security Group IDs to allow connecting with Kafka (port: 9092) | `list(string)` | `[]` | no |
| <a name="input_key_pair_name"></a> [key\_pair\_name](#input\_key\_pair\_name) | SSH key pair to use for system access | `string` | n/a | yes |
| <a name="input_organization"></a> [organization](#input\_organization) | organization name | `string` | `"credeau"` | no |
| <a name="input_private_subnet_id"></a> [private\_subnet\_id](#input\_private\_subnet\_id) | VPC Subnet ID to launch the server network | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS operational region | `string` | `"ap-south-1"` | no |
| <a name="input_ssh_whitelisted_cidrs"></a> [ssh\_whitelisted\_cidrs](#input\_ssh\_whitelisted\_cidrs) | List of CIDR block IP ranges to allow SSH on Kafka instance (port: 22) | `list(string)` | `[]` | no |
| <a name="input_ssh_whitelisted_sg_ids"></a> [ssh\_whitelisted\_sg\_ids](#input\_ssh\_whitelisted\_sg\_ids) | List of Security Group IDs to allow SSH on Kafka instance (port: 22) | `list(string)` | `[]` | no |
| <a name="input_stack_owner"></a> [stack\_owner](#input\_stack\_owner) | owner of the stack | `string` | `"tech@credeau.com"` | no |
| <a name="input_stack_team"></a> [stack\_team](#input\_stack\_team) | team of the stack | `string` | `"devops"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID of the VPC to provision the resources in | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ami_id"></a> [ami\_id](#output\_ami\_id) | AMI ID of the Ubuntu image used for Kafka instance |
| <a name="output_application_identifier"></a> [application\_identifier](#output\_application\_identifier) | Common application-specific identifier used for tagging and metric grouping |
| <a name="output_assets_bucket"></a> [assets\_bucket](#output\_assets\_bucket) | Bucket on which the Kafka bootstrap assets are uploaded |
| <a name="output_availability_zone"></a> [availability\_zone](#output\_availability\_zone) | Availability zone in which the Kafka resources are deployed |
| <a name="output_host_address"></a> [host\_address](#output\_host\_address) | The resolved IP address of the Kafka instance (public or private based on setup) |
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | IAM role ARN attached to the Kafka instances |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | EC2 instance ID for the Kafka host |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | Security group ID attached to the Kafka instance |
<!-- END_TF_DOCS -->