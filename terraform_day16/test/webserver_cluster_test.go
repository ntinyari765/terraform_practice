package test

import (
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestWebserverCluster(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../modules/webserver-cluster",
		Vars: map[string]interface{}{
			"cluster_name":     "test-cluster",
			"environment":      "dev",
			"server_port":      8080,
			"ami":              "ami-0c55b159cbfafe1f0",
			"use_existing_vpc": true,
			"project_name":     "terraform-challenge",
			"team_name":        "devops",
			"alert_email":      "",
		},
	})

	// Always destroy at the end — even if the test fails
	defer terraform.Destroy(t, terraformOptions)

	// Deploy the infrastructure
	terraform.InitAndApply(t, terraformOptions)

	// Get outputs
	clusterName := terraform.Output(t, terraformOptions, "cluster_name")
	instanceType := terraform.Output(t, terraformOptions, "instance_type")

	// Assert outputs are correct
	if clusterName != "test-cluster" {
		t.Errorf("Expected cluster_name to be test-cluster but got %s", clusterName)
	}

	if instanceType != "t3.micro" {
		t.Errorf("Expected instance_type to be t3.micro in dev but got %s", instanceType)
	}

	// Assert the webserver is responding
	albDnsName := terraform.Output(t, terraformOptions, "alb_dns_name")
	url := "http://" + albDnsName

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