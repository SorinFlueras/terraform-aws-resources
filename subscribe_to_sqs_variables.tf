variable "management_account_id" {
  description = "ID of the management account"
  type        = string
}

variable "management_account_automation_role_name" {
  description = "IAM role used in management account. This role is assumed from here to confirm the sns-sqs subscription"
  type        = string
}

variable "sqs_queue_arn" {
  description = "ARN of the SQS queue to which the SNS topic should send messages"
  type        = string
}