# For the sns-sqs subscription to be confirmed automatically,
# the subscription must be made from the sqs owner.
# In order to accomplish this, we define the following provider, which will assume a IAM role
# in the management account
provider "aws" {
  alias  = "sns2sqs"
  region = data.aws_region.current.name

  assume_role {
    role_arn     = "arn:aws:iam::${var.management_account_id}:role/${var.management_account_automation_role_name}"
    session_name = "sns2sqs-${data.aws_region.current.name}"
  }
}

# This resource is used to subscribe the sns topic from the resources account
# to the SQS queue from the management account
resource "aws_sns_topic_subscription" "sns-topic" {
  provider  = "aws.sns2sqs"
  topic_arn = aws_sns_topic.sns-topic.arn
  protocol  = "sqs"
  endpoint  = var.sqs_queue_arn
}