# This resource enables Security Hub
# This resource is created only if the variable enable_security_hub is set to true
resource "aws_securityhub_account" "enabled" {
    count = var.enable_security_hub ? 1 : 0
}