# Default provider
provider "aws" {
  region = var.aws_region
}

locals {
  tags = merge(
    {
      app         = var.app
      environment = var.environment
    },
    var.additional_tags
  )
  name_prefix        = "${var.cur_billing_account.name}-${var.app}-${var.environment}"
  host_domain_name   = var.deploy_app ? "${local.name_prefix}.${data.aws_route53_zone.selected[0].name}" : ""
  parsed_tags        = concat(formatlist("\"user:%s\"", var.resource_user_tags), formatlist("\"aws:%s\"", var.resource_aws_tags))
  resource_tag_names = "[${join(",", local.parsed_tags)}]"
  containers = var.deploy_app ? {
    client = {
      exposed_port     = 443
      internal_port    = 80
      healthcheck_path = "/"
    }
    api = {
      exposed_port     = 4000
      internal_port    = 4000
      healthcheck_path = "/api/healthz"
    }
  } : {}
  scaling_configs = merge(
    {
      default = {
        min_size     = var.asg_size.min
        max_size     = var.asg_size.max
        desired_size = var.asg_size.desired
      }
      zero = {
        min_size     = 0
        max_size     = 0
        desired_size = 0
      }
    },
    var.asg_additional_scaling_configs
  )
}

#########################################
# AutoScaling Group
#########################################

resource "aws_iam_instance_profile" "app" {
  count = var.deploy_app ? 1 : 0

  name = local.name_prefix
  role = aws_iam_role.ccf_api[0].name
}

resource "aws_launch_configuration" "app" {
  count = var.deploy_app ? 1 : 0

  name_prefix          = "${local.name_prefix}-"
  image_id             = var.ami
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.app[0].name
  key_name             = var.key_name
  security_groups      = concat([aws_security_group.app[0].id], var.default_security_group_ids)
  user_data            = data.template_file.user_data[0].rendered

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "app" {
  count = var.deploy_app ? 1 : 0

  name_prefix = "${local.name_prefix}-"

  min_size         = var.asg_size.min
  max_size         = var.asg_size.max
  desired_capacity = var.asg_size.desired

  launch_configuration = aws_launch_configuration.app[0].name
  vpc_zone_identifier  = var.subnet_ids

  health_check_grace_period = var.asg_health_check.grace_period
  health_check_type         = var.asg_health_check.type

  target_group_arns = [for container in keys(local.containers) : aws_lb_target_group.app[container].arn]

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }

  tag {
    key                 = "Name"
    value               = local.name_prefix
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = local.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

resource "aws_autoscaling_schedule" "app" {
  for_each = (var.deploy_app && var.asg_enable_scaling_actions) ? { for scaling_action in var.asg_scaling_actions :
    scaling_action.name => merge(
        local.scaling_configs[scaling_action.scaling_config],
        {
          name = scaling_action.name
          recurrence = scaling_action.cron
        }
    )
  } : {}

  scheduled_action_name  = each.value.name
  min_size               = each.value.min_size
  max_size               = each.value.max_size
  desired_capacity       = each.value.desired_size
  recurrence             = each.value.recurrence
  autoscaling_group_name = aws_autoscaling_group.app[0].name
  time_zone              = var.asg_scaling_actions_timezone
}

resource "aws_lb" "app" {
  count = var.deploy_app ? 1 : 0

  name               = local.name_prefix
  load_balancer_type = "application"
  security_groups    = concat([aws_security_group.app[0].id], var.default_security_group_ids)
  subnets            = var.subnet_ids

  tags = merge(
    local.tags,
    { "Name" = "${local.name_prefix}-alb" }
  )
}

resource "aws_lb_listener" "app" {
  for_each = local.containers

  load_balancer_arn = aws_lb.app[0].arn
  port              = tostring(each.value.exposed_port)
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.certificate_domain_name == "" ? aws_acm_certificate_validation.app[0].certificate_arn : data.aws_acm_certificate.issued[0].arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app[each.key].arn
  }

  tags = merge(
    local.tags,
    { "Name" = "${local.name_prefix}-${each.key}-listener" }
  )
}

resource "aws_lb_listener" "http_redirect" {
  count = var.deploy_app ? 1 : 0

  load_balancer_arn = aws_lb.app[0].arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  tags = merge(
    local.tags,
    { "Name" = "${local.name_prefix}-http-redirect-listener" }
  )
}

resource "aws_lb_target_group" "app" {
  for_each = local.containers

  name     = "${local.name_prefix}-${each.key}"
  port     = each.value.internal_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    matcher  = "200"
    path     = each.value.healthcheck_path
    protocol = "HTTP"
    timeout  = 30
    interval = 60
  }

  tags = merge(
    local.tags,
    { "Name" = "${local.name_prefix}-${each.key}-tg" }
  )
}

#########################################
# Security Group
#########################################

resource "aws_security_group" "app" {
  count = var.deploy_app ? 1 : 0

  name_prefix = "${local.name_prefix}-"
  vpc_id      = var.vpc_id
  description = "Security Group for a Cloud Carbon Footprint app"

  tags = local.tags
}

resource "aws_security_group_rule" "ingress_tcp" {
  for_each = var.deploy_app ? merge(
    { HTTP = { exposed_port = 80 }
    },
    local.containers,
  ) : {}

  security_group_id = aws_security_group.app[0].id

  type        = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
  from_port   = each.value.exposed_port
  to_port     = each.value.exposed_port
  protocol    = "tcp"
  description = "Allow ${each.key} inbound traffic"
}

resource "aws_security_group_rule" "egress_all_traffic" {
  count = var.deploy_app ? 1 : 0

  security_group_id = aws_security_group.app[0].id

  type        = "egress"
  cidr_blocks = ["0.0.0.0/0"]
  protocol    = "-1"
  from_port   = 0
  to_port     = 0
  description = "Allow all outbound traffic"
}

#########################################
# Route 53
#########################################

data "aws_route53_zone" "selected" {
  count = var.deploy_app ? 1 : 0

  name         = var.route53_zone_name
  private_zone = false
}

resource "aws_route53_record" "app" {
  count = var.deploy_app ? 1 : 0

  name    = local.host_domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.selected[0].id

  alias {
    name                   = aws_lb.app[0].dns_name
    zone_id                = aws_lb.app[0].zone_id
    evaluate_target_health = true
  }
}

data "aws_acm_certificate" "issued" {
  count = var.deploy_app && var.certificate_domain_name != "" ? 1 : 0

  domain      = var.certificate_domain_name
  statuses    = ["ISSUED"]
  most_recent = true
}

resource "aws_acm_certificate" "app" {
  count = var.deploy_app && var.certificate_domain_name == "" ? 1 : 0

  domain_name       = aws_route53_record.app[0].name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    local.tags,
    { "Name" = "${local.name_prefix}-cert" }
  )
}

resource "aws_route53_record" "validation" {
  for_each = var.deploy_app && var.certificate_domain_name == "" ? {
    for dvo in aws_acm_certificate.app[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  } : {}

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.selected[0].id
}

resource "aws_acm_certificate_validation" "app" {
  count = var.deploy_app && var.certificate_domain_name == "" ? 1 : 0

  certificate_arn         = aws_acm_certificate.app[0].arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}

#########################################
# IAM
#########################################

data "aws_iam_policy_document" "ec2_assume_role" {
  count = var.deploy_app ? 1 : 0

  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ccf_api" {
  count = var.deploy_app ? 1 : 0

  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role[0].json
  name_prefix        = "${local.name_prefix}-api-"

  tags = merge(
    local.tags,
    { "Name" = "${local.name_prefix}-api-role" }
  )
}

data "aws_iam_policy_document" "cur_assume_role" {
  count = var.deploy_cur ? 0 : 1

  statement {
    actions   = ["sts:AssumeRole"]
    effect    = "Allow"
    resources = ["arn:aws:iam::${var.cur_billing_account.id}:role/${var.cur_target_iam_role_name}"]
  }
}

resource "aws_iam_role_policy" "cur_assume_role" {
  count = var.deploy_cur ? 0 : 1

  name_prefix = "${local.name_prefix}-cur-role-"
  role        = aws_iam_role.ccf_api[0].name
  policy      = data.aws_iam_policy_document.cur_assume_role[0].json
}

data "aws_iam_policy" "additional_policies" {
  for_each = toset(var.deploy_app ? var.additional_policies_arns : [])

  arn = each.key
}

resource "aws_iam_role_policy_attachment" "additional_policies" {
  for_each = toset(var.deploy_app ? var.additional_policies_arns : [])

  role      = aws_iam_role.ccf_api[0].id
  policy_arn = data.aws_iam_policy.additional_policies[each.key].arn
}
