provider "aws" {
  region = "ap-south-1"
  access_key = "AKIAXFM2P45WQVFWRTWL"
  secret_key = "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"
}

# create ebs volume
resource "aws_ebs_volume" "ebs" {
  availability_zone = "ap-south-1a"
  size              = 40

  tags = {
    Name = "First"
  }
}


# ebs volume attach to ec2 instance
resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ebs.id
  instance_id = aws_instance.app.id
}


#ec2 creation
resource "aws_instance" "app" {
  ami               = "ami-05c8ca4485f8b138a"
  availability_zone = "ap-south-1a"
  instance_type     = "t2.micro"

  tags = {
    Name = "First"
  }
}



