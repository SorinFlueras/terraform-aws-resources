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