output "resource_group_arn" {
  description = "ARN of the created resource group"
  value       = var.scan_all_ec2_instances ? null : aws_inspector_resource_group.group[0].arn
}

output "assessment_target_arn" {
  description = "ARN of the assessment target"
  value       = aws_inspector_assessment_target.target.arn
}

output "assessment_template_arn" {
  description = "ARN of the assessment template"
  value       = aws_inspector_assessment_template.template.arn
}

output "cloudwatch_rule_arn" {
  description = "ARN of the rule used to trigger the Inspector assessment template"
  value       = var.schedule_assessment_template ? aws_cloudwatch_event_rule.scheduled[0].arn : null
}