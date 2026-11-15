
resource "aws_cloudwatch_event_rule" "daily_football_collection" {
  name                = "football-analytics-daily-collection"
  description         = "Trigger football data collection every day"
  schedule_expression = "cron(0 6 * * ? *)"

  tags = {
    Project   = "FootballAnalytics"
    ManagedBy = "Terraform"
  }
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.daily_football_collection.name
  target_id = "FootballAnalyticsLambda"
  arn       = aws_lambda_function.football_collector.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowEventBridgeInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.football_collector.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_football_collection.arn
}
