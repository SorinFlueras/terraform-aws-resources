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

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: testFolder,

		Vars: map[string]interface{}{
			"assessment_target_name" : assessmentTargetName,
			"assessment_template_name" : assessmentTemplateName,
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
