package test

import (
    "encoding/json"
    "io/ioutil"
    "testing"
    "github.com/gruntwork-io/terratest/modules/terraform"
)

type Config struct {
    BucketName   string `json:"bucket_name"`
    ACL          string `json:"acl"`
    ObjectKey    string `json:"object_key"`
    ObjectSource string `json:"object_source"`
}

func TestS3Module(t *testing.T) {
    // Load config from a JSON file
    configFile, err := ioutil.ReadFile("config.json")
    if err != nil {
        t.Fatalf("Error reading config file: %v", err)
    }

    var config Config
    if err := json.Unmarshal(configFile, &config); err != nil {
        t.Fatalf("Error unmarshalling config file: %v", err)
    }

    terraformOptions := &terraform.Options{
        TerraformDir: "../module/s3",
        Vars: map[string]interface{}{
            "bucket_name": config.BucketName,
            "acl": config.ACL,
            "object_key": config.ObjectKey,
            "object_source": config.ObjectSource,
        },
    }

    defer terraform.Destroy(t, terraformOptions)
    terraform.InitAndApply(t, terraformOptions)

    outputBucketName := terraform.Output(t, terraformOptions, "bucket_name")
    if outputBucketName != config.BucketName {
        t.Fatalf("Expected bucket name to be %s but got %s", config.BucketName, outputBucketName)
    }

//     outputObjectKey := terraform.Output(t, terraformOptions, "object_key")
//     if outputObjectKey != config.ObjectKey {
//    		t.Fatalf("Expected object key to be %s but got %s", config.ObjectKey, outputObjectKey)
//    	}
//
//    	outputBucketName := terraform.Output(t, terraformOptions, "object_source")
//         if outputBucketName != config.ObjectSource {
//             t.Fatalf("Expected bucket name to be %s but got %s", config.ObjectSource, outputObjectSource)
//         }
//
//    	// Ensure cleanup works by checking that the bucket was destroyed
//    	if terraform.Output(t, terraformOptions, "bucket_name") != "" {
//    	    t.Fatalf("Bucket was not destroyed successfully. It still exists!")
//     }
}
