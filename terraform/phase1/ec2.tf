resource "aws_instance" "aws-and-infra-web-1a" {
  #GitやDockerが入っていないので不適。Session Managerは魅力だが。
  # Amazon Linux 2 AMI (HVM) - Kernel 5.10, SSD Volume Type 鍵タイプ不問　ユーザー名 ec2-user
  #ami           = "ami-0afd8f609f8b8c13b" #大阪リージョン 
  #ami           = "ami-044dbe71ee2d3c59e" #東京リージョン
  # Ubuntu Server 22.04 LTS (HVM), SSD Volume Type ED25519形式 ユーザー名 ubuntu
  #ami           = "ami-0c5a66cf375fc12d8" #大阪リージョン 
  ami            = "ami-0d52744d6551d851e" #東京リージョン
  #docker+MySQLを安定して扱うには、インスタンスを強化する必要あり
  # 東京リージョンではt2を使えなかった。
  instance_type = "t3.small"
  #instance_type="t2.micro"
  subnet_id     = aws_subnet.aws-and-infra-public-subnet-1a.id
  # 注意: Elastic IPをインスタンスに割り当てると、通常のパブリックIPが上書きされます。
  associate_public_ip_address = true
  #main.tfを実行するAWS_ACCESS_KEY_IDにEC2にIAMロールを付与できるポリシーを与えておく。
  iam_instance_profile = "SSMRole"
  #WHIZLABSのsandboxでは使えない。
  #instance_initiated_shutdown_behavior = "stop" 
  #terraformも効かなくなるので注意。
  #disable_api_termination = true
  monitoring = false
  tenancy = "default"
  #public subnet 10.0.10.0の中で決める
  private_ip = "10.0.10.10"
  credit_specification {
    cpu_credits = "unlimited"
  }

  vpc_security_group_ids = [aws_security_group.aws-and-infra-web.id]
  key_name      = "aws-and-infra-ssh-key-tokyo"
  # Amazon Linuxの場合
  # user_data = <<-EOF
  #               #!/bin/bash
  #               sudo yum update -y
  #               sudo yum install git -y
  #               sudo yum install -y docker
  #               sudo systemctl start docker
  #               sudo systemctl enable docker
  #               sudo usermod -aG docker ec2-user
  #               sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  #               sudo chmod +x /usr/local/bin/docker-compose
  #             EOF
  #Ubuntuの場合
  user_data = <<-EOF
                #!/bin/bash
                sudo apt-get update -y
                sudo apt-get install -y docker.io
                sudo systemctl start docker
                sudo systemctl enable docker
                sudo usermod -aG docker ubuntu
                sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
                sudo chmod +x /usr/local/bin/docker-compose
              EOF

  root_block_device {
      volume_size           = 8
      volume_type           = "gp2"
      delete_on_termination = true
      tags = {
        Name = "gp2-dev-ec2"
      }
  }
  tags = {
    Name = "aws-and-infra-web-1a"
  }
}

variable "eip" {
  description = "The Elastic IP to associate with the instance"
  type        = string
}

variable "my_ip" {
  description = "The IP address to be used for security group ingress rule"
  type        = string
}

variable "port_pma" {
  description = "port of phpmyadmin"
  type        = number
}

variable "port_rds" {
  description = "port of RDS"
  type        = number
}

resource "aws_security_group" "aws-and-infra-web" {
  name        = "aws-and-infra-web"
  description = "Security group for allowing SSH from personal IP"
  vpc_id      = aws_vpc.aws-and-infra-vpc.id  

  ingress {
    from_port   = var.port_pma
    to_port     = var.port_pma
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    from_port   = var.port_rds
    to_port     = var.port_rds
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.aws-and-infra-public-subnet-1a.cidr_block]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.aws-and-infra-web-1a.id
  public_ip     = var.eip
}

output "elastic_ip" {
  value = var.eip
}

output "security_group_id"{
    description = "The ID of the security_group"
    value       = aws_security_group.aws-and-infra-web.id
    sensitive = true
}