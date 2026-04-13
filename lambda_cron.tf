resource "aws_lambda_function" "cron" {
  # Biarkan kosong atau arahkan ke dummy file saat pertama kali init
  function_name = "terraform-db-pusher"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.lambda_handler"
  runtime       = "python3.9"

  # Kita tambahin s3 atau dummy supaya terraform gak error pas pertama apply
  # Tapi cara paling gampang buat lab: siapin payload.zip kosong dulu sekali
  filename      = "payload.zip" 

  vpc_config {
    subnet_ids         = [aws_subnet.subnet_a.id]
    security_group_ids = [aws_security_group.lab_sg.id]
  }

  environment {
    variables = {
      DB_HOST = aws_db_instance.db.address
      DB_USER = aws_db_instance.db.username
      DB_PASS = "TerraformLab123!"
      DB_NAME = aws_db_instance.db.db_name
    }
  }
}

resource "aws_cloudwatch_event_rule" "every_5m" {
  name                = "terraform-every-5min"
  schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "target" {
  rule = aws_cloudwatch_event_rule.every_5m.name
  arn  = aws_lambda_function.cron.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cron.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_5m.arn
}