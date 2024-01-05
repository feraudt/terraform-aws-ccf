# Provider for target account CUR report service (only available in us-east-1 currently)
provider "aws" {
  alias  = "cur"
  region = "us-east-1"
}

locals {
  report_name          = "${var.cur_billing_account.name}-cu-report"
  lambda_name          = "${local.report_name}-crawler-trigger"
  s3_cur_path          = var.deploy_cur ? "s3://${aws_cur_report_definition.athena_cur[0].s3_bucket}/${aws_cur_report_definition.athena_cur[0].s3_prefix}/${local.report_name}/${local.report_name}/" : ""
  s3_result_bucket_id  = var.deploy_cur ? aws_s3_bucket.result[0].id : var.cur_query_result_bucket_id
  s3_billing_bucket_id = var.deploy_cur ? aws_s3_bucket.cur[0].id : var.cur_billing_bucket_id
}

#########################################
# S3 result
#########################################

resource "aws_s3_bucket" "result" {
  count    = var.deploy_cur ? 1 : 0
  provider = aws.cur

  bucket_prefix = "${local.name_prefix}-result-"

  tags = merge(
    local.tags,
    { "Name" = "${local.name_prefix}-result" }
  )
}

resource "aws_s3_bucket_public_access_block" "result" {
  count    = var.deploy_cur ? 1 : 0
  provider = aws.cur

  bucket = aws_s3_bucket.result[0].id

  block_public_acls   = true
  block_public_policy = true
}

resource "aws_s3_bucket_versioning" "result" {
  count    = var.deploy_cur ? 1 : 0
  provider = aws.cur

  bucket = aws_s3_bucket.result[0].id
  versioning_configuration {
    status = "Disabled"
  }
}

#########################################
# Cost & Usage Report
#########################################

resource "aws_s3_bucket" "cur" {
  count    = var.deploy_cur ? 1 : 0
  provider = aws.cur

  bucket_prefix = "${local.name_prefix}-cur-"

  tags = merge(
    local.tags,
    { "Name" = "${local.name_prefix}-cur" }
  )
}

resource "aws_s3_bucket_public_access_block" "cur" {
  count    = var.deploy_cur ? 1 : 0
  provider = aws.cur

  bucket = aws_s3_bucket.cur[0].id

  block_public_acls   = true
  block_public_policy = true
}

resource "aws_s3_bucket_versioning" "cur" {
  count    = var.deploy_cur ? 1 : 0
  provider = aws.cur

  bucket = aws_s3_bucket.cur[0].id
  versioning_configuration {
    status = "Disabled"
  }
}

data "aws_kms_key" "s3" {
  count    = var.deploy_cur ? 1 : 0
  provider = aws.cur

  key_id = var.cur_s3_kms_key
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cur" {
  count    = var.deploy_cur ? 1 : 0
  provider = aws.cur

  bucket = aws_s3_bucket.cur[0].id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = data.aws_kms_key.s3[0].arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_policy" "allow_cur_access" {
  count    = var.deploy_cur ? 1 : 0
  provider = aws.cur

  bucket = aws_s3_bucket.cur[0].id
  policy = data.aws_iam_policy_document.allow_cur_access[0].json
}

data "aws_iam_policy_document" "allow_cur_access" {
  count    = var.deploy_cur ? 1 : 0
  provider = aws.cur

  statement {
    principals {
      type        = "Service"
      identifiers = ["billingreports.amazonaws.com"]
    }

    actions = [
      "s3:GetBucketAcl",
      "s3:GetBucketPolicy",
      "s3:PutObject"
    ]

    resources = [aws_s3_bucket.cur[0].arn, "${aws_s3_bucket.cur[0].arn}/*"]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:aws:cur:us-east-1:${var.cur_billing_account.id}:definition/*"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [var.cur_billing_account.id]
    }
  }
}

resource "aws_cur_report_definition" "athena_cur" {
  count    = var.deploy_cur ? 1 : 0
  provider = aws.cur

  report_name = local.report_name

  time_unit                  = var.cur_frequency
  format                     = "Parquet"
  compression                = "Parquet"
  additional_schema_elements = ["RESOURCES"]

  s3_bucket            = aws_s3_bucket.cur[0].id
  s3_prefix            = "${lower(var.cur_frequency)}-cur"
  s3_region            = "us-east-1"
  additional_artifacts = ["ATHENA"]
  report_versioning    = "OVERWRITE_REPORT"

  depends_on = [
    aws_s3_bucket_policy.allow_cur_access[0]
  ]
}

#########################################
# Glue & Athena
#########################################

resource "aws_glue_catalog_database" "cur" {
  count    = var.deploy_cur ? 1 : 0
  provider = aws.cur

  name        = "${local.report_name}-db"
  description = "Contains CUR data based on contents from the S3 bucket '${aws_s3_bucket.cur[0].id}'"
}

resource "aws_glue_crawler" "cur" {
  count    = var.deploy_cur ? 1 : 0
  provider = aws.cur

  name          = "${local.report_name}-crawler"
  database_name = aws_glue_catalog_database.cur[0].name
  role          = aws_iam_role.crawler[0].name

  s3_target {
    path = local.s3_cur_path
  }

  tags = merge(
    local.tags,
    { "Name" = "${local.report_name}-crawler" }
  )

  depends_on = [
    time_sleep.crawler_role
  ]
}

resource "time_sleep" "crawler_role" {
  # Wait for assume role policy propagation across regions
  depends_on      = [aws_iam_role.crawler[0]]
  create_duration = "30s"
}

resource "aws_iam_role" "crawler" {
  count    = var.deploy_cur ? 1 : 0
  provider = aws.cur

  name_prefix        = "${local.report_name}-crawler-"
  assume_role_policy = data.aws_iam_policy_document.crawler_assume_role[0].json

  tags = merge(
    local.tags,
    { "Name" = "${local.report_name}-crawler-role" }
  )
}

resource "aws_iam_role_policy" "crawler" {
  count    = var.deploy_cur ? 1 : 0
  provider = aws.cur

  role   = aws_iam_role.crawler[0].name
  policy = data.aws_iam_policy_document.crawler[0].json
}

data "aws_iam_policy_document" "crawler_assume_role" {
  count    = var.deploy_cur ? 1 : 0
  provider = aws.cur

  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "crawler" {
  count    = var.deploy_cur ? 1 : 0
  provider = aws.cur

  statement {
    sid = "S3Decrypt"

    effect = "Allow"

    actions = [
      "kms:GenerateDataKey",
      "kms:Decrypt",
      "kms:Encrypt",
    ]

    resources = [data.aws_kms_key.s3[0].arn]
  }

  statement {
    sid = "Glue"

    effect = "Allow"

    actions = [
      "glue:ImportCatalogToGlue",
      "glue:GetDatabase",
      "glue:UpdateDatabase",
      "glue:GetTable",
      "glue:CreateTable",
      "glue:UpdateTable",
      "glue:BatchGetPartition",
      "glue:UpdatePartition",
      "glue:BatchCreatePartition",
    ]

    resources = [
      aws_glue_catalog_database.cur[0].arn,
      "arn:${data.aws_partition.current[0].partition}:glue:us-east-1:${var.cur_billing_account.id}:catalog",
      "arn:${data.aws_partition.current[0].partition}:glue:us-east-1:${var.cur_billing_account.id}:table/${aws_glue_catalog_database.cur[0].name}/*",
    ]
  }

  statement {
    sid = "CloudWatch"

    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:${data.aws_partition.current[0].partition}:logs:us-east-1:${var.cur_billing_account.id}:log-group:${aws_cloudwatch_log_group.crawler[0].name}",
      "arn:${data.aws_partition.current[0].partition}:logs:us-east-1:${var.cur_billing_account.id}:log-group:${aws_cloudwatch_log_group.crawler[0].name}:log-stream:*",
    ]
  }

  statement {
    sid = "S3"

    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.cur[0].arn,
      "${aws_s3_bucket.cur[0].arn}/*"
    ]
  }
}

resource "aws_glue_schema" "cur" {
  count    = var.deploy_cur ? 1 : 0
  provider = aws.cur

  schema_name   = "${local.report_name}-schema"
  registry_arn  = aws_glue_registry.cur[0].arn
  data_format   = "AVRO"
  compatibility = "NONE"
  schema_definition = templatefile("${path.module}/templates/cur_schema_tpl.json", {
    user_tag_names = var.resource_user_tags
    aws_tag_names  = var.resource_aws_tags
  })

  tags = merge(
    local.tags,
    { "Name" = "${local.report_name}-schema" }
  )
}

resource "aws_glue_registry" "cur" {
  count    = var.deploy_cur ? 1 : 0
  provider = aws.cur

  registry_name = "${local.report_name}-registry"

  tags = merge(
    local.tags,
    { "Name" = "${local.report_name}-registry" }
  )
}

resource "aws_glue_catalog_table" "cur" {
  count    = var.deploy_cur ? 1 : 0
  provider = aws.cur

  name          = replace(local.report_name, "-", "_")
  database_name = aws_glue_catalog_database.cur[0].name

  table_type = "EXTERNAL_TABLE"

  parameters = {
    EXTERNAL              = "TRUE"
    "parquet.compression" = "SNAPPY"
  }

  storage_descriptor {
    location      = local.s3_cur_path
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    ser_de_info {
      name                  = local.report_name
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"

      parameters = {
        "serialization.format" = 1
      }
    }

    schema_reference {
      schema_id {
        schema_arn = aws_glue_schema.cur[0].arn
      }
      schema_version_number = aws_glue_schema.cur[0].latest_schema_version
    }
  }
}

#########################################
# Notification
#########################################

resource "aws_s3_bucket_notification" "cur" {
  count    = var.deploy_cur ? 1 : 0
  provider = aws.cur

  bucket = aws_s3_bucket.cur[0].id

  lambda_function {
    lambda_function_arn = aws_lambda_function.run_crawler[0].arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "${aws_cur_report_definition.athena_cur[0].s3_prefix}/"
    filter_suffix       = ".parquet"
  }

  depends_on = [
    aws_lambda_permission.allow_bucket_exec[0],
    aws_s3_bucket_policy.allow_cur_access[0]
  ]
}

resource "aws_lambda_function" "run_crawler" {
  count    = var.deploy_cur ? 1 : 0
  provider = aws.cur

  function_name = local.lambda_name

  role = aws_iam_role.lambda[0].arn

  runtime          = "nodejs18.x"
  handler          = "index.handler"
  filename         = data.archive_file.lambda[0].output_path
  source_code_hash = data.archive_file.lambda[0].output_base64sha256
  timeout          = 30

  environment {
    variables = {
      CRAWLER_NAME = aws_glue_crawler.cur[0].name
    }
  }

  depends_on = [
    aws_iam_role_policy.lambda[0],
    aws_cloudwatch_log_group.lambda[0]
  ]
}

data "archive_file" "lambda" {
  count = var.deploy_cur ? 1 : 0

  type        = "zip"
  source_file = var.cur_lambda_func_path
  output_path = "${path.module}/lambda.zip"
}

resource "aws_lambda_permission" "allow_bucket_exec" {
  count    = var.deploy_cur ? 1 : 0
  provider = aws.cur

  statement_id   = "AllowExecutionFromS3Bucket"
  action         = "lambda:InvokeFunction"
  function_name  = aws_lambda_function.run_crawler[0].arn
  source_account = var.cur_billing_account.id
  principal      = "s3.amazonaws.com"
  source_arn     = aws_s3_bucket.cur[0].arn
}

resource "aws_iam_role" "lambda" {
  count    = var.deploy_cur ? 1 : 0
  provider = aws.cur

  name_prefix        = "${local.report_name}-crawler-trigger-"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role[0].json
}

resource "aws_iam_role_policy" "lambda" {
  count    = var.deploy_cur ? 1 : 0
  provider = aws.cur

  role   = aws_iam_role.lambda[0].name
  policy = data.aws_iam_policy_document.crawler_trigger[0].json
}

data "aws_iam_policy_document" "lambda_assume_role" {
  count    = var.deploy_cur ? 1 : 0
  provider = aws.cur

  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "crawler_trigger" {
  count    = var.deploy_cur ? 1 : 0
  provider = aws.cur

  statement {
    sid = "CloudWatch"

    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["${aws_cloudwatch_log_group.lambda[0].arn}:*"]
  }

  statement {
    sid = "Glue"

    effect = "Allow"

    actions = [
      "glue:StartCrawler",
    ]

    resources = [aws_glue_crawler.cur[0].arn]
  }
}

#########################################
# IAM app role
#########################################

data "aws_iam_policy_document" "cur" {
  count    = var.deploy_app ? 0 : 1
  provider = aws.cur

  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.ccf_app_account.id}:root"]
    }
  }
}

resource "aws_iam_role" "cur" {
  count    = var.deploy_app ? 0 : 1
  provider = aws.cur

  assume_role_policy = data.aws_iam_policy_document.cur[0].json
  name_prefix        = "${local.name_prefix}-cur-"

  tags = merge(
    local.tags,
    { "Name" = "${local.name_prefix}-cur-role" }
  )
}

data "aws_iam_policy_document" "s3" {
  count    = var.deploy_cur ? 1 : 0
  provider = aws.cur

  statement {
    actions   = ["s3:*"]
    effect    = "Allow"
    resources = ["arn:aws:s3:::${local.s3_billing_bucket_id}", "arn:aws:s3:::${local.s3_billing_bucket_id}/*"]
  }
  statement {
    actions   = ["s3:*"]
    effect    = "Allow"
    resources = ["arn:aws:s3:::${local.s3_result_bucket_id}", "arn:aws:s3:::${local.s3_result_bucket_id}/*"]
  }
}

data "aws_iam_policy_document" "athena" {
  count    = var.deploy_cur ? 1 : 0
  provider = aws.cur

  statement {
    actions   = ["athena:*"]
    effect    = "Allow"
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "ce" {
  count    = var.deploy_cur ? 1 : 0
  provider = aws.cur

  statement {
    actions   = ["ce:GetRightsizingRecommendation"]
    effect    = "Allow"
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "glue" {
  count    = var.deploy_cur ? 1 : 0
  provider = aws.cur

  statement {
    actions   = ["glue:*"]
    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "s3" {
  count    = var.deploy_cur ? 1 : 0
  provider = aws.cur

  name_prefix = "${local.name_prefix}-api-s3-"
  role        = var.deploy_app ? aws_iam_role.ccf_api[0].name : aws_iam_role.cur[0].name
  policy      = data.aws_iam_policy_document.s3[0].json
}

resource "aws_iam_role_policy" "athena" {
  count    = var.deploy_cur ? 1 : 0
  provider = aws.cur

  name_prefix = "${local.name_prefix}-api-athena-"
  role        = var.deploy_app ? aws_iam_role.ccf_api[0].name : aws_iam_role.cur[0].name
  policy      = data.aws_iam_policy_document.athena[0].json
}

resource "aws_iam_role_policy" "ce" {
  count    = var.deploy_cur ? 1 : 0
  provider = aws.cur

  name_prefix = "${local.name_prefix}-api-ce-"
  role        = var.deploy_app ? aws_iam_role.ccf_api[0].name : aws_iam_role.cur[0].name
  policy      = data.aws_iam_policy_document.ce[0].json
}

resource "aws_iam_role_policy" "glue" {
  count    = var.deploy_cur ? 1 : 0
  provider = aws.cur

  name_prefix = "${local.name_prefix}-api-glue-"
  role        = var.deploy_app ? aws_iam_role.ccf_api[0].name : aws_iam_role.cur[0].name
  policy      = data.aws_iam_policy_document.glue[0].json
}

#########################################
# AWS managed
#########################################

resource "aws_cloudwatch_log_group" "crawler" {
  count    = var.deploy_cur ? 1 : 0
  provider = aws.cur

  name              = "/aws-glue/crawlers"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "lambda" {
  count    = var.deploy_cur ? 1 : 0
  provider = aws.cur

  name              = "/aws/lambda/${local.lambda_name}"
  retention_in_days = 14
}

data "aws_partition" "current" {
  count    = var.deploy_cur ? 1 : 0
  provider = aws.cur
}
