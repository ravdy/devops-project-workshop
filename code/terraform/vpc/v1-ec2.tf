provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "demo-server" {
    ami = "ami-007855ac798b5175e"
    instance_type = "t2.small"
    key_name = "dpo"
    vpc_security_group_ids = [aws_security_group.demo-sg.id]
    subnet_id = aws_subnet.dpw-public_subent_01.id 
    for_each = toset(["Jenkins-master", "Jenkins-slave", "Ansible"])
   tags = {
     Name = "${each.key}"
   }
}

resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  vpc_id = aws_vpc.dpw-vpc.id
  ingress {
    description      = "ssh access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "Jenkins GUI access"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "demo-server-sg"
  }
}

resource "aws_vpc" "dpw-vpc" {
       cidr_block = "10.1.0.0/16"
       tags = {
        Name = "dpw-vpc"
     }
   }

//Create a Subnet 
resource "aws_subnet" "dpw-public_subent_01" {
    vpc_id = aws_vpc.dpw-vpc.id
    cidr_block = "10.1.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1a"
    tags = {
      Name = "dpw-public_subent_01"
    }
}
//Create extra Subnet 
resource "aws_subnet" "dpw-public_subent_02" {
    vpc_id = aws_vpc.dpw-vpc.id
    cidr_block = "10.1.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1b"
    tags = {
      Name = "dpw-public_subent_02"
    }
}
//Creating an Internet Gateway 
resource "aws_internet_gateway" "dpw-igw" {
    vpc_id = aws_vpc.dpw-vpc.id
    tags = {
      Name = "dpw-igw"
    }
}

// Create a route table 
resource "aws_route_table" "dpw-public-rt" {
    vpc_id = aws_vpc.dpw-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.dpw-igw.id
    }
    tags = {
      Name = "dpw-public-rt"
    }
}

// Associate subnet-01 with route table
resource "aws_route_table_association" "dpw-rta-public-subent-1" {
    subnet_id = aws_subnet.dpw-public_subent_01.id
    route_table_id = aws_route_table.dpw-public-rt.id
}

// Associate subnet-02 with route table
resource "aws_route_table_association" "dpw-rta-public-subent-2" {
    subnet_id = aws_subnet.dpw-public_subent_02.id
    route_table_id = aws_route_table.dpw-public-rt.id
}

    module "sgs" {
      source = "../sg_eks"
      vpc_id     =     aws_vpc.dpw-vpc.id
 }

 module "eks" {
       source = "../eks"
        vpc_id     =     aws_vpc.dpw-vpc.id
        subnet_ids = [aws_subnet.dpw-public_subent_01.id,aws_subnet.dpw-public_subent_02.id]
        sg_ids = module.sgs.security_group_public
  }