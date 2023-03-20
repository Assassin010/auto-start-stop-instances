######################## EVENTBRIDGE  AUTO STOP ########################

resource "aws_cloudwatch_event_rule" "ec2_stop_rule" {
  name                = "StopEC2Instances"
  description         = "Stop EC2 nodes at 19:00 from Monday to friday"
  schedule_expression = "cron(0 18 ? * 2-6 *)"

  tags = merge(
    local.common_tags
  )

}
resource "aws_cloudwatch_event_target" "ec2_stop_rule_target" {
  rule       = aws_cloudwatch_event_rule.ec2_stop_rule.name
  target_id  = "SendToLambda"
  arn        = aws_lambda_function.auto-stop.arn
  depends_on = [aws_lambda_function.auto-stop]
}

resource "aws_lambda_permission" "allow_cloudwatch_stop" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = var.function_name1
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ec2_stop_rule.arn
  depends_on    = [aws_lambda_function.auto-stop]
}

######################## EVENTBRIDGE  AUTO START ########################

resource "aws_cloudwatch_event_rule" "ec2_start_rule" {
  name                = "StartEC2Instances"
  description         = "Start EC2 nodes at 9:00 from Monday to friday"
  schedule_expression = "cron(0 8 ? * 2-6 *)"

  tags = merge(
    local.common_tags
  )

}

resource "aws_cloudwatch_event_target" "ec2_start_rule_target" {
  rule       = aws_cloudwatch_event_rule.ec2_start_rule.name
  target_id  = "SendToLambda"
  arn        = aws_lambda_function.auto-start.arn
  depends_on = [aws_lambda_function.auto-start]
}

resource "aws_lambda_permission" "allow_cloudwatch_start" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = var.function_name2
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ec2_start_rule.arn
  depends_on    = [aws_lambda_function.auto-start]
}
