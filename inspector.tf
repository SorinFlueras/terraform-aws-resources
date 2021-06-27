# This resource creates a resource group
# The resource group is used to group EC2 instances that should be included in
# an assessment target
# The EC2 instances are selected by providing their tags in the ec2_tags variable
resource "aws_inspector_resource_group" "group" {
  # if all ec2 instances should be scanned, then this resource is not needed
  count = var.scan_all_ec2_instances ? 0 : 1 
  tags  = var.ec2_tags
}

# This resource creates an assessment_target
# If scan_all_ec2_instances is set to true, all instances all scanned. Otherwise, only
# instances included in the resource group are scanned.
resource "aws_inspector_assessment_target" "target" {
  name               = var.assessment_target_name
  resource_group_arn = var.scan_all_ec2_instances ? null : aws_inspector_resource_group.group[0].arn
}

# This resource creates and assessment template
# This template uses rules packages to scan the selected instance from the
# assessment target
resource "aws_inspector_assessment_template" "template" {
  name       = var.assessment_template_name
  target_arn = aws_inspector_assessment_target.target.arn
  duration   = var.assessment_duration

  # If no rules are selected, using the rules_packages variable, then use all existing rules packages
  rules_package_arns = length(var.rules_packages) == 0 ? data.aws_inspector_rules_packages.rules.arns : var.rules_packages
}

# This resource creates the IAM role that provides the necessary
# permissions for the EventBridge (CloudWatch) rule target
# The resource is created only if schedule_assessment_template is set to true
resource "aws_iam_role" "scheduled" {
  count              = var.schedule_assessment_template ? 1 : 0
  name               = var.iam_role_name
  assume_role_policy = data.aws_iam_policy_document.inspector_assume_role.json
}

# This resource creates and attaches the IAM policy that will be used by aws_iam_role.scheduled
# The resource is created only if schedule_assessment_template is set to true
resource "aws_iam_role_policy" "inspector_policy" {
  count  = var.schedule_assessment_template ? 1 : 0
  name   = var.iam_policy_name 
  role   = aws_iam_role.scheduled[0].id
  policy = data.aws_iam_policy_document.inspector_policy.json
}

# This resource creates an EventBridge (CloudWatch) Rule to trigger the
# assessment_template periodically, according to the provided 
# cron expression
# The resource is created only if schedule_assessment_template is set to true
resource "aws_cloudwatch_event_rule" "scheduled" {
  count               = var.schedule_assessment_template ? 1 : 0
  name                = var.cloudwatch_rule_name
  description         = var.cloudwatch_rule_description
  schedule_expression = var.cloudwatch_rule_cron_expression
}

# This resource is used to provide the assessment template as
# a target for the Cloudwatch rule aws_cloudwatch_event_rule.scheduled
# The resource is created only if schedule_assessment_template is set to true
resource "aws_cloudwatch_event_target" "scheduled" {
  count    = var.schedule_assessment_template ? 1 : 0
  rule     = aws_cloudwatch_event_rule.scheduled[0].name
  arn      = aws_inspector_assessment_template.template.arn
  role_arn = aws_iam_role.scheduled[0].arn
}