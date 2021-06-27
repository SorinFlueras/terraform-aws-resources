# resource "aws_kms_key" "sns-topic" {
#   description         = "KMS key used for the Inspector SNS topic"
#   enable_key_rotation = true
#   policy              = aws_iam_policy_document.sns_key_policy.json
# }

resource "aws_sns_topic" "sns-topic" {
  name              = var.sns_topic_name
  policy            = data.aws_iam_policy_document.sns_topic_policy.json
#   kms_master_key_id = aws_kms_key.sns-topic.key_id
}


# This resource is used to subscribe the Inspector assessment template to the sns topic
resource "null_resource" "subscribe_assessment_run_completed" {
  depends_on = [
    aws_sns_topic.sns-topic,
  ]
  provisioner "local-exec" {
    command = "aws inspector subscribe-to-event --event ASSESSMENT_RUN_COMPLETED --resource-arn ${aws_inspector_assessment_template.template.arn} --topic-arn ${aws_sns_topic.sns-topic.arn} --region ${data.aws_region.current.name}"
  }
  triggers = {
    template_arn = aws_inspector_assessment_template.template.arn
    topic_arn    = aws_sns_topic.sns-topic.arn
  }
}