output "app_route53_record_name" {
  description = "The domain name attached to the CCF app"
  value       = var.deploy_app ? aws_route53_record.app[0].name : ""
}

output "cur_target_iam_role_name" {
  description = "The name of the IAM role in the target account to be assumed by the app instance"
  value       = var.deploy_app ? "" : aws_iam_role.cur[0].name
}

output "cur_glue_db_name" {
  description = "The name of the Glue db containing the CUR table in the target account"
  value       = var.deploy_cur ? aws_glue_catalog_database.cur[0].name : ""
}

output "cur_glue_table_name" {
  description = "The name of the Glue table containing the CUR in the target account"
  value       = var.deploy_cur ? aws_glue_catalog_table.cur[0].name : ""
}

output "cur_billing_bucket_id" {
  description = "The id of the S3 bucket containing the CUR in the target account"
  value       = var.deploy_cur ? aws_s3_bucket.cur[0].id : ""
}

output "cur_query_result_bucket_id" {
  description = "The id of the S3 bucket containing the Athena query results in the target account"
  value       = var.deploy_cur ? aws_s3_bucket.result[0].id : ""
}
