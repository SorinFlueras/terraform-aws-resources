package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
)

func TestTerraformAws (t *testing.T) {
	t.Parallel()

	testType := "plan"

	testFolder := test_structure.CopyTerraformFolderToTemp(t, "../../", "terraform-aws-resources")

	awsRegion := "us-east-1"

	assessmentTemplateName := "test-template"
	assessmentTargetName := "test-target"
	snsTopicName := "test-sns-topic-for-inspector"
	managementAccountId := "123456789012"
	managementAccountAutomationRoleName := "terraform-cicd-role"
	sqsQueueArn := "arn:aws:sqs:us-east-1:444455556666:queue1"

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: testFolder,

		Vars: map[string]interface{}{
			"assessment_target_name" : assessmentTargetName,
			"assessment_template_name" : assessmentTemplateName,
			"sns_topic_name" : snsTopicName,
			"sqs_queue_arn" : sqsQueueArn,
			"management_account_automation_role_name" : managementAccountAutomationRoleName,
			"management_account_id" : managementAccountId,
		},

		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
		},
	})

	switch testType {
	case "plan" :
		terraform.InitAndPlan(t, terraformOptions)
	case "apply":
		terraform.InitAndApply(t, terraformOptions)
	case "destroy":
		defer terraform.Destroy(t, terraformOptions)
		terraform.Init(t, terraformOptions)
	case "applyanddestroy":
		defer terraform.Destroy(t, terraformOptions)
		terraform.InitAndApply(t, terraformOptions)
	}
}
