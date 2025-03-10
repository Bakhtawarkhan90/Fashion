provider "aws" {
  region = "us-east-1" 
}

resource "aws_s3_bucket" "s3" {
  bucket = "goku9027"
} 

resource "aws_security_group" "sg" {
   name = "CN"  

}


resource "aws_instance" "ec2" {
  
  ami = "04b4f1a9cf54c11d"
  instance_type = "t2.micro" 
  key_name = "DevOps"
  vpc_security_group_ids = [data.aws_security_group.sg.id]
  tags = {
  Name = "Terraform"
  volumes = "Terraform" 
  } 

}
