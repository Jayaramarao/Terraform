# creating policy
resource "aws_iam_policy" "ec2_policy" {
  name        = "ec2_policy"
  
  description = "Provides full access to Amazon EC2 via the AWS Management Console"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

# create a role
resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    NAME = "EC2_ROLE"
  }
}

# Attach the role to the policy
resource "aws_iam_role_policy_attachment" "ec2_policy_role" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}

# Creating instance profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_role.name
}


# Attach insatnce profile to the ec2 insatnce
provider "aws" {
  region        = "ap-south-1"
  access_key    = "AKIAXFM2P45WVO5R5P4I"
  secret_key    = "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"
}

resource "aws_instance" "app_server" {
  ami           = "ami-079b5e5b3971bd10d"
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  tags = {
    name = "terraform"
  }
}
