output "resource_group_arn" {
  description = "ARN of the created resource group"
  value       = var.scan_all_ec2_instances ? null : aws_inspector_resource_group.group[0].arn
}

output "assessment_target_arn" {
  description = "ARN of the assessment target"
  value       = aws_inspector_assessment_target.target.arn
}