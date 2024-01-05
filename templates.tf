data "local_file" "nginx_conf" {
  count = var.deploy_app ? 1 : 0

  filename = var.nginx_conf_path
}

data "template_file" "user_data" {
  count = var.deploy_app ? 1 : 0

  template = file(var.user_data_path)

  vars = {
    docker_compose           = data.template_file.docker_compose[0].rendered
    nginx_conf               = data.local_file.nginx_conf[0].content
    additional_bash_commands = var.user_data_additional_bash_commands
  }
}

data "template_file" "docker_compose" {
  count = var.deploy_app ? 1 : 0

  template = file(var.docker_compose_path)

  vars = {
    # Images
    ccf_api_image      = var.ccf_api_image.name
    ccf_api_version    = var.ccf_api_image.version
    ccf_client_image   = var.ccf_client_image.name
    ccf_client_version = var.ccf_client_image.version
    # Client env
    ## Endpoint
    host_domain_name = local.host_domain_name
    ## React app
    react_previous_year_of_usage      = tostring(var.ccf_react_previous_year_of_usage)
    react_group_by                    = var.ccf_react_group_by
    react_start_date                  = var.ccf_react_start_date
    react_end_date                    = var.ccf_react_end_date
    react_date_range_value            = tostring(var.ccf_react_date_range_value)
    react_date_range_type             = var.ccf_react_date_range_type
    react_min_date_age                = tostring(var.ccf_react_min_date_age)
    react_base_url                    = var.ccf_react_base_url
    react_disable_cache               = tostring(var.ccf_react_disable_cache)
    react_disable_forecast_validation = tostring(var.ccf_react_disable_forecast_validation)
    react_page_limit                  = tostring(var.ccf_react_page_limit)
    # API env
    ## AWS
    aws_target_account_role_name    = var.deploy_cur ? aws_iam_role.ccf_api[0].name : var.cur_target_iam_role_name
    aws_include_estimates           = tostring(var.ccf_aws_include_estimates)
    aws_use_billing_data            = tostring(var.ccf_aws_use_billing_data)
    aws_athena_db_name              = var.deploy_cur ? aws_glue_catalog_database.cur[0].name : var.cur_glue_db_name
    aws_athena_db_table             = var.deploy_cur ? aws_glue_catalog_table.cur[0].name : var.cur_glue_table_name
    aws_athena_region               = "us-east-1"
    aws_query_result_location       = "s3://${local.s3_result_bucket_id}"
    aws_billing_account_id          = var.cur_billing_account.id
    aws_billing_account_name        = var.cur_billing_account.name
    aws_cloud_usage_target_accounts = var.ccf_aws_cloud_usage_target_accounts
    aws_auth_mode                   = var.deploy_cur ? "EC2-METADATA" : "AWS"
    aws_recommendations_service     = var.ccf_aws_recommendations_service
    aws_compute_optimizer_bucket    = var.ccf_aws_compute_optimizer_bucket
    aws_resource_tag_names          = local.resource_tag_names
    ## GCP
    gcp_query_data = var.ccf_gcp_query_data
    gcp_include_estimates                 = tostring(var.ccf_gcp_include_estimates)
    gcp_use_billing_data                  = tostring(var.ccf_gcp_use_billing_data)
    gcp_application_credentials           = var.ccf_gcp_application_credentials_path
    gcp_big_query_table                   = var.ccf_gcp_big_query_table
    gcp_billing_project_id                = var.ccf_gcp_billing_project.id
    gcp_billing_project_name              = var.ccf_gcp_billing_project.name
    gcp_cloud_usage_target_projects       = var.ccf_gcp_cloud_usage_target_projects
    gcp_use_carbon_free_energy_percentage = tostring(var.ccf_gcp_use_carbon_free_energy_percentage)
    gcp_vcpus_per_gke_cluster             = tostring(var.ccf_gcp_vcpus_per_gke_cluster)
    gcp_vcpus_per_composer_env            = tostring(var.ccf_gcp_vcpus_per_composer_env)
    ## Azure
    azure_query_data = var.ccf_gcp_query_data
    azure_include_estimates                = tostring(var.ccf_azure_include_estimates)
    azure_use_billing_data                 = tostring(var.ccf_azure_use_billing_data)
    azure_client_id                        = var.ccf_azure_client_id
    azure_client_secret                    = var.ccf_azure_client_secret
    azure_tenant_id                        = var.ccf_azure_tenant_id
    azure_auth_mode                        = var.ccf_azure_auth_mode
    azure_resource_tag_names               = var.ccf_azure_resource_tag_names
    azure_consumption_chunk_days           = tostring(var.ccf_azure_consumption_chunk_days)
    azure_subscription_chunks              = tostring(var.ccf_azure_subscription_chunks)
    azure_cloud_usage_target_subscriptions = var.ccf_azure_cloud_usage_target_subscriptions
    ## GCS
    gcs_cache_mode        = var.ccf_gcs_cache_mode
    gcs_cache_bucket_name = var.ccf_gcs_cache_bucket_name
    ## On-Premise
    on_prem_cpu_util_server   = tostring(var.ccf_on_prem_cpu_util_server)
    on_prem_cpu_util_laptop   = tostring(var.ccf_on_prem_cpu_util_laptop)
    on_prem_cpu_util_desktop  = tostring(var.ccf_on_prem_cpu_util_desktop)
    on_prem_avg_watts_server  = tostring(var.ccf_on_prem_avg_watts_server)
    on_prem_avg_watts_laptop  = tostring(var.ccf_on_prem_avg_watts_laptop)
    on_prem_avg_watts_desktop = tostring(var.ccf_on_prem_avg_watts_desktop)
    ## CORS
    cors_enable       = tostring(var.ccf_cors_enable)
    cors_allow_origin = var.ccf_cors_allow_origin
    ## Other
    electricity_maps_token = var.ccf_electricity_maps_token
  }
}
