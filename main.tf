provider "aws" {
  region = "us-east-1"  # Update with your desired region
}

resource "aws_lambda_function" "example_function" {
  function_name = "example-function"
  role          = aws_iam_role.example_role.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"
  timeout       = 10
  memory_size   = 128

  tracing_config {
    mode = "Active"
  }

  environment {
    variables = {
      EXAMPLE_ENV_VAR = "example-value"
    }
  }
}

resource "aws_iam_role" "example_role" {
  name = "example-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "example_policy" {
  name        = "example-policy"
  description = "Example IAM policy for Lambda function"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "xray:PutTraceSegments",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "xray:PutTelemetryRecords",
        "xray:GetSamplingRules",
        "xray:GetSamplingTargets",
        "xray:GetSamplingStatisticSummaries",
        "xray:GetTraceGraph",
        "xray:GetServiceGraph",
        "xray:GetTimeSeriesServiceStatistics",
        "xray:GetTraceSummaries",
        "xray:BatchGetTraces"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "example_policy_attachment" {
  policy_arn = aws_iam_policy.example_policy.arn
  role       = aws_iam_role.example_role.name
}
