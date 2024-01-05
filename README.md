# terraform-aws-ccf

This Terraform module provides a production grade [Cloud Carbon Footprint](https://github.com/cloud-carbon-footprint/cloud-carbon-footprint) deployment with all the necessary infrastructure on AWS.

It also features an optional AWS Cost & Usage Report service in case none is already available.

Connection & authentication against AWS CUR is natively included.
Additional connection & authentication settings for GCP and Azure can be specified through input variables.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.4.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.27 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 2.4.0 |
| <a name="requirement_template"></a> [template](#requirement\_template) | ~> 2.2.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | ~> 0.6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.4.0 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.76.1 |
| <a name="provider_aws.cur"></a> [aws.cur](#provider\_aws.cur) | 3.76.1 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.4.1 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |
| <a name="provider_time"></a> [time](#provider\_time) | 0.6.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_autoscaling_group.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_cloudwatch_log_group.crawler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cur_report_definition.athena_cur](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cur_report_definition) | resource |
| [aws_glue_catalog_database.cur](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_catalog_database) | resource |
| [aws_glue_catalog_table.cur](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_catalog_table) | resource |
| [aws_glue_crawler.cur](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_crawler) | resource |
| [aws_glue_registry.cur](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_registry) | resource |
| [aws_glue_schema.cur](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_schema) | resource |
| [aws_iam_instance_profile.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy_attachment.additional_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_role.ccf_api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.crawler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.cur](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.athena](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.ce](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.crawler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.cur_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.glue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_lambda_function.run_crawler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.allow_bucket_exec](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_launch_configuration.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration) | resource |
| [aws_lb.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.http_redirect](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_route53_record.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_s3_bucket.cur](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.result](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_notification.cur](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_s3_bucket_policy.allow_cur_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.cur](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_public_access_block.result](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.cur](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.cur](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_versioning.result](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_security_group.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.egress_all_traffic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress_tcp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [time_sleep.crawler_role](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [archive_file.lambda](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_acm_certificate.issued](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [aws_iam_policy.additional_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy_document.allow_cur_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.athena](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ce](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.crawler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.crawler_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.crawler_trigger](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cur](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cur_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ec2_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.glue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lambda_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_kms_key.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_route53_zone.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [local_file.nginx_conf](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |
| [template_file.docker_compose](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.user_data](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_policies_arns"></a> [additional\_policies\_arns](#input\_additional\_policies\_arns) | The ARNs of existing IAM policies to attach to the instance profile role in addition to the ones created by this module | `list(string)` | `[]` | no |
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | The tags to add to the resources | `map(any)` | <pre>{<br>  "project": "green-it",<br>  "terraform_managed": true<br>}</pre> | no |
| <a name="input_ami"></a> [ami](#input\_ami) | The image id to build the instance from (set empty for CUR ONLY deployments) | `string` | n/a | yes |
| <a name="input_app"></a> [app](#input\_app) | The name of this app | `string` | `"ccf"` | no |
| <a name="input_asg_health_check"></a> [asg\_health\_check](#input\_asg\_health\_check) | The health check settings of the instances autoscalling group | <pre>object({<br>    grace_period = number<br>    type         = string<br>  })</pre> | <pre>{<br>  "grace_period": 300,<br>  "type": "EC2"<br>}</pre> | no |
| <a name="input_asg_size"></a> [asg\_size](#input\_asg\_size) | The capacity settings of the instances autoscalling group | <pre>object({<br>    min     = number<br>    max     = number<br>    desired = number<br>  })</pre> | <pre>{<br>  "desired": 1,<br>  "max": 2,<br>  "min": 1<br>}</pre> | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The region to deploy into (set empty for CUR ONLY deployments) | `string` | n/a | yes |
| <a name="input_ccf_api_image"></a> [ccf\_api\_image](#input\_ccf\_api\_image) | The name and version tag of the CCF api image to deploy | <pre>object({<br>    name    = string<br>    version = string<br>  })</pre> | <pre>{<br>  "name": "docker.io/cloudcarbonfootprint/api",<br>  "version": "latest"<br>}</pre> | no |
| <a name="input_ccf_app_account"></a> [ccf\_app\_account](#input\_ccf\_app\_account) | The name and id of the AWS account where the CCF app will be deployed (for CUR ONLY deployments) | <pre>object({<br>    name = string<br>    id   = string<br>  })</pre> | <pre>{<br>  "id": "",<br>  "name": ""<br>}</pre> | no |
| <a name="input_ccf_aws_cloud_usage_target_accounts"></a> [ccf\_aws\_cloud\_usage\_target\_accounts](#input\_ccf\_aws\_cloud\_usage\_target\_accounts) | The list of accounts to retrieve data from with Cloud Usage API approach if AWS\_USE\_BILLING\_DATA=false (format: "[{"id":"<account1\_id>","name":"<account1\_name>"},{...}]") | `string` | `""` | no |
| <a name="input_ccf_aws_compute_optimizer_bucket"></a> [ccf\_aws\_compute\_optimizer\_bucket](#input\_ccf\_aws\_compute\_optimizer\_bucket) | The name of the AWS bucket in which Compute Optimizer recommendations exist (only for ComputeOptimizer or All AWS\_RECOMMENDATIONS\_SERVICE | `string` | `""` | no |
| <a name="input_ccf_aws_include_estimates"></a> [ccf\_aws\_include\_estimates](#input\_ccf\_aws\_include\_estimates) | Use this to include AWS estimations | `bool` | `true` | no |
| <a name="input_ccf_aws_recommendations_service"></a> [ccf\_aws\_recommendations\_service](#input\_ccf\_aws\_recommendations\_service) | The AWS service used to get recommendations from (RightSizing/ComputeOptimizer/All) | `string` | `"Rightsizing"` | no |
| <a name="input_ccf_aws_use_billing_data"></a> [ccf\_aws\_use\_billing\_data](#input\_ccf\_aws\_use\_billing\_data) | Use this to configure the application to query Cost and Usage Reports via AWS Athena | `bool` | `true` | no |
| <a name="input_ccf_azure_auth_mode"></a> [ccf\_azure\_auth\_mode](#input\_ccf\_azure\_auth\_mode) | The authentication mode for Azure | `string` | `"default"` | no |
| <a name="input_ccf_azure_client_id"></a> [ccf\_azure\_client\_id](#input\_ccf\_azure\_client\_id) | The Azure Service Principal ID with permission to read the Consumption API from your Subscriptions | `string` | `""` | no |
| <a name="input_ccf_azure_client_secret"></a> [ccf\_azure\_client\_secret](#input\_ccf\_azure\_client\_secret) | The Azure Service Principal Secret with permission to read the Consumption API from your Subscriptions | `string` | `""` | no |
| <a name="input_ccf_azure_cloud_usage_target_subscriptions"></a> [ccf\_azure\_cloud\_usage\_target\_subscriptions](#input\_ccf\_azure\_cloud\_usage\_target\_subscriptions) | List of subscriptions by IDs to include in estimations (format: ["sub\_1","..."]) | `string` | `""` | no |
| <a name="input_ccf_azure_consumption_chunk_days"></a> [ccf\_azure\_consumption\_chunk\_days](#input\_ccf\_azure\_consumption\_chunk\_days) | Use this to specify the chunk size to avoid rate limiting | `number` | `5` | no |
| <a name="input_ccf_azure_include_estimates"></a> [ccf\_azure\_include\_estimates](#input\_ccf\_azure\_include\_estimates) | Use this to include Azure estimations | `bool` | `true` | no |
| <a name="input_ccf_azure_query_data"></a> [ccf\_azure\_query\_data](#input\_ccf\_azure\_query\_data) | Whether the app should query for Azure data or not | `bool` | `false` | no |
| <a name="input_ccf_azure_resource_tag_names"></a> [ccf\_azure\_resource\_tag\_names](#input\_ccf\_azure\_resource\_tag\_names) | Azure resource tag names to include if present, include resourceGroup as a tag name if needed (format: ["tag\_1","..."]) | `string` | `"[\"resourceGroup\", \"project\", \"customer\"]"` | no |
| <a name="input_ccf_azure_subscription_chunks"></a> [ccf\_azure\_subscription\_chunks](#input\_ccf\_azure\_subscription\_chunks) | Use this to specify a group size of subscipritions for asynchronous requests to avoid rate limiting | `number` | `10` | no |
| <a name="input_ccf_azure_tenant_id"></a> [ccf\_azure\_tenant\_id](#input\_ccf\_azure\_tenant\_id) | Your Azure tenant id | `string` | `""` | no |
| <a name="input_ccf_azure_use_billing_data"></a> [ccf\_azure\_use\_billing\_data](#input\_ccf\_azure\_use\_billing\_data) | Use this to configure the application to query Azure Consumption API | `bool` | `true` | no |
| <a name="input_ccf_client_image"></a> [ccf\_client\_image](#input\_ccf\_client\_image) | The name and version tag of the CCF client image to deploy | <pre>object({<br>    name    = string<br>    version = string<br>  })</pre> | <pre>{<br>  "name": "docker.io/cloudcarbonfootprint/client",<br>  "version": "latest"<br>}</pre> | no |
| <a name="input_ccf_cors_allow_origin"></a> [ccf\_cors\_allow\_origin](#input\_ccf\_cors\_allow\_origin) | A list of one or more origins to allow for CORS requests, comma separated | `string` | `""` | no |
| <a name="input_ccf_cors_enable"></a> [ccf\_cors\_enable](#input\_ccf\_cors\_enable) | Enables default CORS headers on all API requests | `bool` | `true` | no |
| <a name="input_ccf_electricity_maps_token"></a> [ccf\_electricity\_maps\_token](#input\_ccf\_electricity\_maps\_token) | Enable the use of Electricity Maps API for realtime carbon intensity emissions factors instead of the default values | `string` | `""` | no |
| <a name="input_ccf_gcp_application_credentials_path"></a> [ccf\_gcp\_application\_credentials\_path](#input\_ccf\_gcp\_application\_credentials\_path) | The absolute path to your service account private key file | `string` | `""` | no |
| <a name="input_ccf_gcp_big_query_table"></a> [ccf\_gcp\_big\_query\_table](#input\_ccf\_gcp\_big\_query\_table) | The name of your BigQuery table configured to consume Billing Export data | `string` | `""` | no |
| <a name="input_ccf_gcp_billing_project"></a> [ccf\_gcp\_billing\_project](#input\_ccf\_gcp\_billing\_project) | The GCP Project id and name that your service account exists in | <pre>object({<br>    id   = string<br>    name = string<br>  })</pre> | <pre>{<br>  "id": "",<br>  "name": ""<br>}</pre> | no |
| <a name="input_ccf_gcp_cloud_usage_target_projects"></a> [ccf\_gcp\_cloud\_usage\_target\_projects](#input\_ccf\_gcp\_cloud\_usage\_target\_projects) | This is array of objects with keys id and name that match the target GCP Projects with Cloud Usage API approach if GCP\_USE\_BILLING\_DATA=false (format: "[{"id":"<account1\_id>","name":"<account1\_name>"},{...}]") | `string` | `""` | no |
| <a name="input_ccf_gcp_include_estimates"></a> [ccf\_gcp\_include\_estimates](#input\_ccf\_gcp\_include\_estimates) | Use this to include GCP estimations | `bool` | `true` | no |
| <a name="input_ccf_gcp_query_data"></a> [ccf\_gcp\_query\_data](#input\_ccf\_gcp\_query\_data) | Whether the app should query for GCP data or not | `bool` | `false` | no |
| <a name="input_ccf_gcp_use_billing_data"></a> [ccf\_gcp\_use\_billing\_data](#input\_ccf\_gcp\_use\_billing\_data) | Use this to configure the application to query Billing Export Data via Google BigQuery | `bool` | `true` | no |
| <a name="input_ccf_gcp_use_carbon_free_energy_percentage"></a> [ccf\_gcp\_use\_carbon\_free\_energy\_percentage](#input\_ccf\_gcp\_use\_carbon\_free\_energy\_percentage) | Setting this to true will change the emissions factors used by the application to take into account Google's Carbon Free Energy percentage in each region | `bool` | `true` | no |
| <a name="input_ccf_gcp_vcpus_per_composer_env"></a> [ccf\_gcp\_vcpus\_per\_composer\_env](#input\_ccf\_gcp\_vcpus\_per\_composer\_env) | Use this to configure the average number of vCPUs the application should use to estimate energy consumption of Cloud Composer Environments | `number` | `14` | no |
| <a name="input_ccf_gcp_vcpus_per_gke_cluster"></a> [ccf\_gcp\_vcpus\_per\_gke\_cluster](#input\_ccf\_gcp\_vcpus\_per\_gke\_cluster) | Use this to configure the average number of vCPUs the application should use to estimate energy consumption of Kubernetes Engine clusters | `number` | `3` | no |
| <a name="input_ccf_gcs_cache_bucket_name"></a> [ccf\_gcs\_cache\_bucket\_name](#input\_ccf\_gcs\_cache\_bucket\_name) | Is the name of you Google Cloud Storage bucket where the cache file will be stored | `string` | `""` | no |
| <a name="input_ccf_gcs_cache_mode"></a> [ccf\_gcs\_cache\_mode](#input\_ccf\_gcs\_cache\_mode) | Set with GCS to use this option or leave it empty to use the default | `string` | `""` | no |
| <a name="input_ccf_on_prem_avg_watts_desktop"></a> [ccf\_on\_prem\_avg\_watts\_desktop](#input\_ccf\_on\_prem\_avg\_watts\_desktop) | For on-premise servers, provides an average value for average watts | `number` | `300` | no |
| <a name="input_ccf_on_prem_avg_watts_laptop"></a> [ccf\_on\_prem\_avg\_watts\_laptop](#input\_ccf\_on\_prem\_avg\_watts\_laptop) | For on-premise servers, provides an average value for average watts | `number` | `300` | no |
| <a name="input_ccf_on_prem_avg_watts_server"></a> [ccf\_on\_prem\_avg\_watts\_server](#input\_ccf\_on\_prem\_avg\_watts\_server) | For on-premise servers, provides an average value for average watts | `number` | `300` | no |
| <a name="input_ccf_on_prem_cpu_util_desktop"></a> [ccf\_on\_prem\_cpu\_util\_desktop](#input\_ccf\_on\_prem\_cpu\_util\_desktop) | For on-premise servers, provides an average value for cpu utilization | `number` | `40` | no |
| <a name="input_ccf_on_prem_cpu_util_laptop"></a> [ccf\_on\_prem\_cpu\_util\_laptop](#input\_ccf\_on\_prem\_cpu\_util\_laptop) | For on-premise servers, provides an average value for cpu utilization | `number` | `40` | no |
| <a name="input_ccf_on_prem_cpu_util_server"></a> [ccf\_on\_prem\_cpu\_util\_server](#input\_ccf\_on\_prem\_cpu\_util\_server) | For on-premise servers, provides an average value for cpu utilization | `number` | `40` | no |
| <a name="input_ccf_react_base_url"></a> [ccf\_react\_base\_url](#input\_ccf\_react\_base\_url) | The base URL used to make API requests | `string` | `""` | no |
| <a name="input_ccf_react_date_range_type"></a> [ccf\_react\_date\_range\_type](#input\_ccf\_react\_date\_range\_type) | The legacy type of time period to be used (day/week/month/quarter/year) | `string` | `"month"` | no |
| <a name="input_ccf_react_date_range_value"></a> [ccf\_react\_date\_range\_value](#input\_ccf\_react\_date\_range\_value) | The legacy quantity of REACT\_APP\_DATE\_RANGE\_TYPE to be used | `number` | `1` | no |
| <a name="input_ccf_react_disable_cache"></a> [ccf\_react\_disable\_cache](#input\_ccf\_react\_disable\_cache) | Set to true to disable caching | `bool` | `false` | no |
| <a name="input_ccf_react_disable_forecast_validation"></a> [ccf\_react\_disable\_forecast\_validation](#input\_ccf\_react\_disable\_forecast\_validation) | Set to true to disable recommendations forecast validation | `bool` | `false` | no |
| <a name="input_ccf_react_end_date"></a> [ccf\_react\_end\_date](#input\_ccf\_react\_end\_date) | Set the date range to query data based on custom start/end timestamps (format: mm-dd-yyyy) | `string` | `""` | no |
| <a name="input_ccf_react_group_by"></a> [ccf\_react\_group\_by](#input\_ccf\_react\_group\_by) | Value to set how the cloud provider queries should return data (day/week/month/quarter/year) | `string` | `"day"` | no |
| <a name="input_ccf_react_min_date_age"></a> [ccf\_react\_min\_date\_age](#input\_ccf\_react\_min\_date\_age) | The legacy amount of days to subtract from current date as end date | `number` | `30` | no |
| <a name="input_ccf_react_page_limit"></a> [ccf\_react\_page\_limit](#input\_ccf\_react\_page\_limit) | The pagination limit for fetched estimates per request | `number` | `50000` | no |
| <a name="input_ccf_react_previous_year_of_usage"></a> [ccf\_react\_previous\_year\_of\_usage](#input\_ccf\_react\_previous\_year\_of\_usage) | Use this to ensure the application requests usage data from the entire previous calendar year to today | `bool` | `true` | no |
| <a name="input_ccf_react_start_date"></a> [ccf\_react\_start\_date](#input\_ccf\_react\_start\_date) | The date range to query data based on custom start/end timestamps (format: mm-dd-yyyy) | `string` | `""` | no |
| <a name="input_certificate_domain_name"></a> [certificate\_domain\_name](#input\_certificate\_domain\_name) | The domain name of the certificate for HTTPS if it has already been issued (with wildcards if needed) | `string` | `""` | no |
| <a name="input_cur_billing_account"></a> [cur\_billing\_account](#input\_cur\_billing\_account) | The name and id of the AWS target account where the billing report is | <pre>object({<br>    name = string<br>    id   = string<br>  })</pre> | <pre>{<br>  "id": "",<br>  "name": ""<br>}</pre> | no |
| <a name="input_cur_billing_bucket_id"></a> [cur\_billing\_bucket\_id](#input\_cur\_billing\_bucket\_id) | The name of the S3 cur billing data bucket on the target account for APP ONLY deployments | `string` | `""` | no |
| <a name="input_cur_frequency"></a> [cur\_frequency](#input\_cur\_frequency) | The time unit of the CUR report (DAILY, HOURLY, MONTHLY) | `string` | `"DAILY"` | no |
| <a name="input_cur_glue_db_name"></a> [cur\_glue\_db\_name](#input\_cur\_glue\_db\_name) | The name of your target AWS Athena Database with CUR data for APP ONLY deployments | `string` | `""` | no |
| <a name="input_cur_glue_table_name"></a> [cur\_glue\_table\_name](#input\_cur\_glue\_table\_name) | The name of your target AWS Athena Table with CUR data for APP ONLY deployments | `string` | `""` | no |
| <a name="input_cur_lambda_func_path"></a> [cur\_lambda\_func\_path](#input\_cur\_lambda\_func\_path) | The path to the lambda function file, this module provides one under the templates directory | `string` | `"src/index.js"` | no |
| <a name="input_cur_query_result_bucket_id"></a> [cur\_query\_result\_bucket\_id](#input\_cur\_query\_result\_bucket\_id) | The target AWS S3 Bucket that you want your Athena query results to reside in for APP ONLY deployments | `string` | `""` | no |
| <a name="input_cur_s3_kms_key"></a> [cur\_s3\_kms\_key](#input\_cur\_s3\_kms\_key) | The ID of the KMS key used for the S3 CUR bucket encryption | `string` | `"alias/aws/s3"` | no |
| <a name="input_cur_target_iam_role_name"></a> [cur\_target\_iam\_role\_name](#input\_cur\_target\_iam\_role\_name) | The name of the IAM role to assume in the target acccount for APP ONLY deployments | `string` | `""` | no |
| <a name="input_default_security_group_ids"></a> [default\_security\_group\_ids](#input\_default\_security\_group\_ids) | The list of security group IDs to add to the instances in the ASG (set empty for CUR ONLY deployments) | `list(string)` | n/a | yes |
| <a name="input_deploy_app"></a> [deploy\_app](#input\_deploy\_app) | Whether to deploy the CCF app and create the required resources or not | `bool` | `true` | no |
| <a name="input_deploy_cur"></a> [deploy\_cur](#input\_deploy\_cur) | Whether to deploy the CUR resources & services or not | `bool` | `false` | no |
| <a name="input_docker_compose_path"></a> [docker\_compose\_path](#input\_docker\_compose\_path) | The path to the docker-compose.yml file, this module provides one under the templates directory | `string` | `"docker/docker-compose-tpl.yml"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The deployment environent name | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The size of the instances | `string` | `"t3.medium"` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | The name of the key to SSH into the instances | `string` | `""` | no |
| <a name="input_nginx_conf_path"></a> [nginx\_conf\_path](#input\_nginx\_conf\_path) | The path to the nginx.conf file, this module provides one under the templates directory | `string` | `"nginx/nginx.conf"` | no |
| <a name="input_resource_aws_tags"></a> [resource\_aws\_tags](#input\_resource\_aws\_tags) | The keys of the AWS tags to include in the report table to allow resources grouping and filtering | `list(string)` | <pre>[<br>  "createdBy"<br>]</pre> | no |
| <a name="input_resource_user_tags"></a> [resource\_user\_tags](#input\_resource\_user\_tags) | The keys of the user tags to include in the report table to allow resources grouping and filtering | `list(string)` | <pre>[<br>  "app",<br>  "environment",<br>  "project"<br>]</pre> | no |
| <a name="input_route53_zone_name"></a> [route53\_zone\_name](#input\_route53\_zone\_name) | The domain name of the hosted zone to create the app host domain into (set empty for CUR ONLY deployments) | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | The list of subnet IDs to add to the instances in the ASG (set empty for CUR ONLY deployments) | `list(string)` | n/a | yes |
| <a name="input_user_data_additional_bash_commands"></a> [user\_data\_additional\_bash\_commands](#input\_user\_data\_additional\_bash\_commands) | Any bash commands to execute in the user\_data script (before sarting containers), typically your container registry login commands | `string` | `""` | no |
| <a name="input_user_data_path"></a> [user\_data\_path](#input\_user\_data\_path) | The path to the user\_data script file, this module provides one under the templates directory | `string` | `"templates/user_data_tpl.sh"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the target VPC to deploy the app resources into (set empty for CUR ONLY deployments) | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_route53_record_name"></a> [app\_route53\_record\_name](#output\_app\_route53\_record\_name) | The domain name attached to the CCF app |
| <a name="output_cur_billing_bucket_id"></a> [cur\_billing\_bucket\_id](#output\_cur\_billing\_bucket\_id) | The id of the S3 bucket containing the CUR in the target account |
| <a name="output_cur_glue_db_name"></a> [cur\_glue\_db\_name](#output\_cur\_glue\_db\_name) | The name of the Glue db containing the CUR table in the target account |
| <a name="output_cur_glue_table_name"></a> [cur\_glue\_table\_name](#output\_cur\_glue\_table\_name) | The name of the Glue table containing the CUR in the target account |
| <a name="output_cur_query_result_bucket_id"></a> [cur\_query\_result\_bucket\_id](#output\_cur\_query\_result\_bucket\_id) | The id of the S3 bucket containing the Athena query results in the target account |
| <a name="output_cur_target_iam_role_name"></a> [cur\_target\_iam\_role\_name](#output\_cur\_target\_iam\_role\_name) | The name of the IAM role in the target account to be assumed by the app instance |
