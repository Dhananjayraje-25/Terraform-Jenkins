provider "aws" {
    region = "ap-south-1"  
}

resource "aws_instance" "foo" {
  ami           = "ami-048d6ed8eabb546f1" # ap-south-1
  instance_type = "t3.micro"
  tags = {
      Name = "TF-Instance"
  }
}
