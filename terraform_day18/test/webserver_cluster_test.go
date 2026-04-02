package test

import (
    "fmt"
    "strings"
    "testing"
    "time"

    http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
    "github.com/gruntwork-io/terratest/modules/random"
    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/stretchr/testify/assert"
)

func TestWebserverClusterIntegration(t *testing.T) {
	t.Parallel()

	// Generate unique cluster name to avoid conflicts
	uniqueID    := strings.ToLower(random.UniqueId())
    clusterName := fmt.Sprintf("test-cluster-%s", uniqueID)

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../modules/webserver-cluster",
		Vars: map[string]interface{}{
			"cluster_name":     clusterName,
			"environment":      "dev",
			"server_port":      8080,
			"ami":              "ami-0622c21dd3d2b1075",
			"use_existing_vpc": true,
			"project_name":     "terraform-challenge",
			"team_name":        "devops",
			"alert_email":      "",
		},
	})

	// Always destroy at the end — even if assertions fail
	defer terraform.Destroy(t, terraformOptions)

	// Deploy real infrastructure
	terraform.InitAndApply(t, terraformOptions)

	// Wait for instance to boot
    time.Sleep(60 * time.Second)

	// Assert outputs are correct
	actualClusterName := terraform.Output(t, terraformOptions, "cluster_name")
	actualInstanceType := terraform.Output(t, terraformOptions, "instance_type")
	actualMinSize      := terraform.Output(t, terraformOptions, "min_size")
	actualMaxSize      := terraform.Output(t, terraformOptions, "max_size")

	assert.Equal(t, clusterName, actualClusterName)
	assert.Equal(t, "t3.micro", actualInstanceType)
	assert.Equal(t, "1", actualMinSize)
	assert.Equal(t, "3", actualMaxSize)

	// Assert webserver is responding
	instanceIP := terraform.Output(t, terraformOptions, "instance_ip")
	url        := fmt.Sprintf("http://%s:8080", instanceIP)

	http_helper.HttpGetWithRetry(
    t,
    url,
    nil,
    200,
    "Hello, World",
    30,
    10*time.Second,
)
}