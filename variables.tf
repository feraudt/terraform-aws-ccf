#########################################
# Env
#########################################

variable "vpc_id" {
  description = "The ID of the target VPC to deploy the app resources into (set empty for CUR ONLY deployments)"
  type        = string
}

variable "subnet_ids" {
  description = "The list of subnet IDs to add to the instances in the ASG (set empty for CUR ONLY deployments)"
  type        = list(string)
}

variable "default_security_group_ids" {
  description = "The list of security group IDs to add to the instances in the ASG (set empty for CUR ONLY deployments)"
  type        = list(string)
}

variable "aws_region" {
  description = "The region to deploy into (set empty for CUR ONLY deployments)"
  type        = string
}

variable "environment" {
  description = "The deployment environent name"
  type        = string
}

variable "app" {
  description = "The name of this app"
  type        = string
  default     = "ccf"
}

variable "additional_tags" {
  description = "The tags to add to the resources"
  type        = map(any)
  default = {
    project           = "green-it"
    terraform_managed = true
  }
}

variable "deploy_app" {
  description = "Whether to deploy the CCF app and create the required resources or not"
  type        = bool
  default     = true
}

variable "deploy_cur" {
  description = "Whether to deploy the CUR resources & services or not"
  type        = bool
  default     = false
}

#########################################
# Infra config
#########################################

variable "ami" {
  description = "The image id to build the instance from (set empty for CUR ONLY deployments)"
  type        = string
}

variable "instance_type" {
  description = "The size of the instances"
  type        = string
  default     = "t3.medium"
}

variable "key_name" {
  description = "The name of the key to SSH into the instances"
  type        = string
  default     = ""
}

variable "asg_size" {
  description = "The capacity settings of the instances autoscalling group"
  type = object({
    min     = number
    max     = number
    desired = number
  })
  default = {
    min     = 1
    max     = 2
    desired = 1
  }
}

variable "asg_enable_scaling_actions" {
  description = "Wether to activate ASG scaling actions defined in asg_scaling_actions or not"
  type = bool
  default = false
}

variable "asg_scaling_actions_timezone" {
  description = "The timezone used for scaling actions"
  type = string
  default = "Europe/Paris"
}

variable "asg_scaling_actions" {
  description = "The cron expressions and scaling configs name to configure recurring ASG scaling actions ('default' config with values from asg_size and 'zero' already exist, additional configs can be defined in asg_additional_scaling_configs)"
  type = list(object({
    name = string
    cron = string
    scaling_config = string
  }))
  default = []
}

variable "asg_additional_scaling_configs" {
  description = "Additional ASG scaling configs than can be referenced in asg_scaling_actions (a 'default' config with the values from asg_size and a 'zero' config already exist)"
  type = map(object({
    min_size     = number
    max_size     = number
    desired_size = number
  }))
  default = {}
}

variable "asg_health_check" {
  description = "The health check settings of the instances autoscalling group"
  type = object({
    grace_period = number
    type         = string
  })
  default = {
    grace_period = 300
    type         = "EC2"
  }
}

variable "user_data_path" {
  description = "The path to the user_data script file, this module provides one under the templates directory"
  type        = string
  default     = "templates/user_data.sh.tftpl"
}

variable "docker_compose_path" {
  description = "The path to the docker-compose.yml file, this module provides one under the templates directory"
  type        = string
  default     = "docker/docker-compose.yml.tftpl"
}

variable "nginx_conf_path" {
  description = "The path to the nginx.conf file, this module provides one under the templates directory"
  type        = string
  default     = "nginx/nginx.conf.tftpl"
}

variable "route53_zone_name" {
  description = "The domain name of the hosted zone to create the app host domain into (set empty for CUR ONLY deployments)"
  type        = string
}

variable "certificate_domain_name" {
  description = "The domain name of the certificate for HTTPS if it has already been issued (with wildcards if needed)"
  type        = string
  default     = ""
}

variable "additional_policies_arns" {
  description = "The ARNs of existing IAM policies to attach to the instance profile role in addition to the ones created by this module"
  type        = list(string)
  default     = []
}

variable "user_data_additional_bash_commands" {
  description = "Any bash commands to execute in the user_data script (before sarting containers), typically your container registry login commands"
  type        = string
  default     = ""
}

#########################################
# CUR config
#########################################

variable "cur_billing_account" {
  description = "The name and id of the AWS target account where the billing report is"
  type = object({
    name = string
    id   = string
  })
  default = {
    name = ""
    id   = ""
  }
}

variable "cur_s3_kms_key" {
  description = "The ID of the KMS key used for the S3 CUR bucket encryption"
  type        = string
  default     = "alias/aws/s3"
}

variable "cur_frequency" {
  description = "The time unit of the CUR report (DAILY, HOURLY, MONTHLY)"
  type        = string
  default     = "DAILY"
}

variable "cur_lambda_func_path" {
  description = "The path to the lambda function file, this module provides one under the templates directory"
  type        = string
  default     = "src/index.js"
}

variable "cur_query_result_bucket_id" {
  description = "The target AWS S3 Bucket that you want your Athena query results to reside in for APP ONLY deployments"
  type        = string
  default     = ""
}

variable "cur_billing_bucket_id" {
  description = "The name of the S3 cur billing data bucket on the target account for APP ONLY deployments"
  type        = string
  default     = ""
}

variable "cur_target_iam_role_name" {
  description = "The name of the IAM role to assume in the target acccount for APP ONLY deployments"
  type        = string
  default     = ""
}

variable "cur_glue_db_name" {
  description = "The name of your target AWS Athena Database with CUR data for APP ONLY deployments"
  type        = string
  default     = ""
}

variable "cur_glue_table_name" {
  description = "The name of your target AWS Athena Table with CUR data for APP ONLY deployments"
  type        = string
  default     = ""
}

#########################################
# App config
#########################################

variable "ccf_app_account" {
  description = "The name and id of the AWS account where the CCF app will be deployed (for CUR ONLY deployments)"
  type = object({
    name = string
    id   = string
  })
  default = {
    name = ""
    id   = ""
  }
}

variable "ccf_api_image" {
  description = "The name and version tag of the CCF api image to deploy"
  type = object({
    name    = string
    version = string
  })
  default = {
    name    = "docker.io/cloudcarbonfootprint/api"
    version = "latest"
  }
}

variable "ccf_client_image" {
  description = "The name and version tag of the CCF client image to deploy"
  type = object({
    name    = string
    version = string
  })
  default = {
    name    = "docker.io/cloudcarbonfootprint/client"
    version = "latest"
  }
}

variable "ccf_aws_include_estimates" {
  description = "Use this to include AWS estimations"
  type        = bool
  default     = true
}

variable "ccf_aws_use_billing_data" {
  description = "Use this to configure the application to query Cost and Usage Reports via AWS Athena"
  type        = bool
  default     = true
}

variable "ccf_aws_cloud_usage_target_accounts" {
  description = "The list of accounts to retrieve data from with Cloud Usage API approach if AWS_USE_BILLING_DATA=false (format: \"[{\"id\":\"<account1_id>\",\"name\":\"<account1_name>\"},{...}]\")"
  type        = string
  default     = ""
}

variable "ccf_aws_recommendations_service" {
  description = "The AWS service used to get recommendations from (RightSizing/ComputeOptimizer/All)"
  type        = string
  default     = "Rightsizing"
}

variable "ccf_aws_compute_optimizer_bucket" {
  description = "The name of the AWS bucket in which Compute Optimizer recommendations exist (only for ComputeOptimizer or All AWS_RECOMMENDATIONS_SERVICE"
  type        = string
  default     = ""
}

variable "resource_user_tags" {
  description = "The keys of the user tags to include in the report table to allow resources grouping and filtering"
  type        = list(string)
  default     = ["app", "environment", "project"]
}

variable "resource_aws_tags" {
  description = "The keys of the AWS tags to include in the report table to allow resources grouping and filtering"
  type        = list(string)
  default     = ["createdBy"]
}

variable "ccf_gcp_query_data" {
  description = "Whether the app should query for GCP data or not"
  type = bool
  default = false
}

variable "ccf_gcp_include_estimates" {
  description = "Use this to include GCP estimations"
  type        = bool
  default     = true
}

variable "ccf_gcp_use_billing_data" {
  description = "Use this to configure the application to query Billing Export Data via Google BigQuery"
  type        = bool
  default     = true
}

variable "ccf_gcp_application_credentials_path" {
  description = "The absolute path to your service account private key file"
  type        = string
  default     = ""
}

variable "ccf_gcp_big_query_table" {
  description = "The name of your BigQuery table configured to consume Billing Export data"
  type        = string
  default     = ""
}

variable "ccf_gcp_billing_project" {
  description = "The GCP Project id and name that your service account exists in"
  type = object({
    id   = string
    name = string
  })
  default = {
    id   = ""
    name = ""
  }
}

variable "ccf_gcp_cloud_usage_target_projects" {
  description = "This is array of objects with keys id and name that match the target GCP Projects with Cloud Usage API approach if GCP_USE_BILLING_DATA=false (format: \"[{\"id\":\"<account1_id>\",\"name\":\"<account1_name>\"},{...}]\")"
  type        = string
  default     = ""
}

variable "ccf_gcp_use_carbon_free_energy_percentage" {
  description = "Setting this to true will change the emissions factors used by the application to take into account Google's Carbon Free Energy percentage in each region"
  type        = bool
  default     = true
}

variable "ccf_gcp_vcpus_per_gke_cluster" {
  description = "Use this to configure the average number of vCPUs the application should use to estimate energy consumption of Kubernetes Engine clusters"
  type        = number
  default     = 3
}

variable "ccf_gcp_vcpus_per_composer_env" {
  description = "Use this to configure the average number of vCPUs the application should use to estimate energy consumption of Cloud Composer Environments"
  type        = number
  default     = 14
}

variable "ccf_azure_query_data" {
  description = "Whether the app should query for Azure data or not"
  type = bool
  default = false
}

variable "ccf_azure_include_estimates" {
  description = "Use this to include Azure estimations"
  type        = bool
  default     = true
}

variable "ccf_azure_use_billing_data" {
  description = "Use this to configure the application to query Azure Consumption API"
  type        = bool
  default     = true
}

variable "ccf_azure_client_id" {
  description = "The Azure Service Principal ID with permission to read the Consumption API from your Subscriptions"
  type        = string
  default     = ""
}

variable "ccf_azure_client_secret" {
  description = "The Azure Service Principal Secret with permission to read the Consumption API from your Subscriptions"
  type        = string
  default     = ""
}

variable "ccf_azure_tenant_id" {
  description = "Your Azure tenant id"
  type        = string
  default     = ""
}

variable "ccf_azure_auth_mode" {
  description = "The authentication mode for Azure"
  type        = string
  default     = "default"
}

variable "ccf_azure_resource_tag_names" {
  description = "Azure resource tag names to include if present, include resourceGroup as a tag name if needed (format: [\"tag_1\",\"...\"])"
  type        = string
  default     = "[\"resourceGroup\", \"project\", \"customer\"]"
}

variable "ccf_azure_consumption_chunk_days" {
  description = "Use this to specify the chunk size to avoid rate limiting"
  type        = number
  default     = 5
}

variable "ccf_azure_subscription_chunks" {
  description = "Use this to specify a group size of subscipritions for asynchronous requests to avoid rate limiting"
  type        = number
  default     = 10
}

variable "ccf_azure_cloud_usage_target_subscriptions" {
  description = "List of subscriptions by IDs to include in estimations (format: [\"sub_1\",\"...\"])"
  type        = string
  default     = ""
}

variable "ccf_gcs_cache_mode" {
  description = "Set with GCS to use this option or leave it empty to use the default"
  type        = string
  default     = ""
}

variable "ccf_gcs_cache_bucket_name" {
  description = "Is the name of you Google Cloud Storage bucket where the cache file will be stored"
  type        = string
  default     = ""
}

variable "ccf_on_prem_cpu_util_server" {
  description = "For on-premise servers, provides an average value for cpu utilization"
  type        = number
  default     = 40
}

variable "ccf_on_prem_cpu_util_laptop" {
  description = "For on-premise servers, provides an average value for cpu utilization"
  type        = number
  default     = 40
}

variable "ccf_on_prem_cpu_util_desktop" {
  description = "For on-premise servers, provides an average value for cpu utilization"
  type        = number
  default     = 40
}

variable "ccf_on_prem_avg_watts_server" {
  description = "For on-premise servers, provides an average value for average watts"
  type        = number
  default     = 300
}

variable "ccf_on_prem_avg_watts_laptop" {
  description = "For on-premise servers, provides an average value for average watts"
  type        = number
  default     = 300
}

variable "ccf_on_prem_avg_watts_desktop" {
  description = "For on-premise servers, provides an average value for average watts"
  type        = number
  default     = 300
}

variable "ccf_cors_enable" {
  description = "Enables default CORS headers on all API requests"
  type        = bool
  default     = true
}

variable "ccf_cors_allow_origin" {
  description = "A list of one or more origins to allow for CORS requests, comma separated"
  type        = string
  default     = ""
}

variable "ccf_electricity_maps_token" {
  description = "Enable the use of Electricity Maps API for realtime carbon intensity emissions factors instead of the default values"
  type        = string
  default     = ""
}

variable "ccf_react_previous_year_of_usage" {
  description = "Use this to ensure the application requests usage data from the entire previous calendar year to today"
  type        = bool
  default     = true
}

variable "ccf_react_group_by" {
  description = "Value to set how the cloud provider queries should return data (day/week/month/quarter/year)"
  type        = string
  default     = "day"
}

variable "ccf_react_start_date" {
  description = "The date range to query data based on custom start/end timestamps (format: mm-dd-yyyy)"
  type        = string
  default     = ""
}

variable "ccf_react_end_date" {
  description = "Set the date range to query data based on custom start/end timestamps (format: mm-dd-yyyy)"
  type        = string
  default     = ""
}

variable "ccf_react_date_range_value" {
  description = "The legacy quantity of REACT_APP_DATE_RANGE_TYPE to be used"
  type        = number
  default     = 1
}

variable "ccf_react_date_range_type" {
  description = "The legacy type of time period to be used (day/week/month/quarter/year)"
  type        = string
  default     = "month"
}

variable "ccf_react_min_date_age" {
  description = "The legacy amount of days to subtract from current date as end date"
  type        = number
  default     = 30
}

variable "ccf_react_base_url" {
  description = "The base URL used to make API requests"
  type        = string
  default     = ""
}

variable "ccf_react_disable_cache" {
  description = "Set to true to disable caching"
  type        = bool
  default     = false
}

variable "ccf_react_disable_forecast_validation" {
  description = "Set to true to disable recommendations forecast validation"
  type        = bool
  default     = false
}

variable "ccf_react_page_limit" {
  description = "The pagination limit for fetched estimates per request"
  type        = number
  default     = 50000
}
