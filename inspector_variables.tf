# This variable is optional
variable "scan_all_ec2_instances" {
  description = "Set to true if all EC2 instances should be scanned. Set to false if a resource group should be created."
  type        = bool
  default     = true
}

# This variable is required only if scan_all_ec2_instances is set to false
variable "ec2_tags" {
  description = "Map of tags used to select desired EC2 instances."
  type        = map(string)
  default     = null
}

# This variable is required
variable "assessment_target_name" {
  description = "Name of the assessment target"
  type        = string
}

# This variable is required
variable "assessment_template_name" {
  description = "Name of the assessment template"
  type        = string
}

# This variable is optional
variable "assessment_duration" {
  description = "Duration (in seconds) of the assessment template"
  type        = number
  default     = 3600
}

# This variable is optional
variable "rules_packages" {
  description = "List of selected rule arns. E.g. arn:aws:inspector:us-west-2:758058086616:rulespackage/0-9hgA516p"
  type        = list(string)
  default     = []
}

# This variable is optional
variable "schedule_assessment_template" {
  description = "Set this variable to true if the Inspector assessment template should be scheduled according to a cron expression"
  type        = bool
  default     = false
}

# This variable is required only if schedule_assessment_template is set to true
variable "cloudwatch_rule_name" {
  description = "Name of the cloudwatch rule used to schedule the Inspector assessment template"
  type        = string
  default     = null  
}

# This variable is required only if schedule_assessment_template is set to true
variable "cloudwatch_rule_description" {
  description = "Description of the cloudwatch rule used to schedule the Inspector assessment template"
  type        = string
  default     = null
}

# This variable is required only if schedule_assessment_template is set to true
variable "cloudwatch_rule_cron_expression" {
  description = "Cron expression used for the cloudwatch rule used to schedule the Inspector assessment template"
  type        = string
  default     = null 
}

# This variable is required only if schedule_assessment_template is set to true
variable "iam_role_name" {
  description = "Name of the IAM Role used by the CloudWatch rule"
  type        = string
  default     = null 
}

# This variable is required only if schedule_assessment_template is set to true
variable "iam_policy_name" {
  description = "Name of the IAM Policy used by the IAM Role mentioned above"
  type        = string
  default     = null 
}