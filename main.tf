resource "aws_security_group" "demosg" {
  name        = "severaccess"
  description = "This is to allow server to outside"


  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }


  tags = {
    Name = "newvpc"
  }
}
resource "aws_instance" "demoinstance" {
  ami                  = "ami-02e136e904f3da870"
  instance_type        = "t2.micro"
  security_groups      = ["${aws_security_group.demosg.name}"]
  iam_instance_profile = aws_iam_instance_profile.demoprofile.id

  tags = {
    Name = "newinstance"
  }
}

resource "aws_ebs_volume" "demovolume" {
  availability_zone = "us-east-1a"
  size              = 5

  tags = {
    Name = "ebsvolume"
  }
}
resource "aws_iam_role" "demoiam" {
  name = "webrole"
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
      }
    ]
  })

  tags = {
    tag-key = "newrole"
  }
}

resource "aws_iam_policy_attachment" "demoattachment" {
  name       = "attachment"
  roles      = ["${aws_iam_role.demoiam.id}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"

}

resource "aws_iam_instance_profile" "demoprofile" {
  name = "web"
  role = aws_iam_role.demoiam.name
}


