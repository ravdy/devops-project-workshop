## Write your 1st terraform file

Lets create an EC2 instance as part of our 1st terraform file

To create an ec2 instance, We should connect to aws account first 

in terraform file 
we can connect to aws cloud using 'provider block'
to create an ec2 instance, should use 'resource block'
1. In provider block, mention cloud name, and region name 
   ```sh 
   provider "aws" {
   project = "acme-app"
   region  = "us-central1"
   }
   ```

1. in resource block, we should mention information to create instance. 
2. To create an EC2 instance (object) we should have below informaiton 
    - Instance name
    - Operating system (AMI)
    - nstance Type 
    - Keypair
    - VPC
    - Storage
   
But among these instance type and AMI are mandatory arguments.
These should be defined in the resource block
```sh 
 resource "aws_instance" "web" {
  ami           = "ami-a1b2c3d4"
  instance_type = "t2.micro"
 }
```

So final file looks [like this](v1-ec2.tf)
