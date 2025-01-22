package test

import (
    "testing"
    "github.com/gruntwork-io/terratest/modules/terraform"
)

func TestS3Module(t *testing.T) {
    terraformOptions := &terraform.Options{
        TerraformDir: "../module/s3",
        Vars: map[string]interface{}{
            "bucket_name": "test-bucket",
            "acl": "private",
            "object_key": "example-key",
            "object_source": "example-source",
        },
    }

    defer terraform.Destroy(t, terraformOptions)
    terraform.InitAndApply(t, terraformOptions)

    bucketName := terraform.Output(t, terraformOptions, "bucket_name")
    if bucketName != "test-bucket" {
        t.Fatalf("Expected bucket name to be test-bucket but got %s", bucketName)
    }
}
