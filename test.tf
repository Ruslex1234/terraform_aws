# Create a VPC
resource "aws_vpc" "rodsvpc" {
  cidr_block = "${var.cidr_range}"
  tags = {Name = "rodsvpc"}
}
# Create private subnet one
resource "aws_subnet" "privatesub1" {
  vpc_id = aws_vpc.rodsvpc.id
  cidr_block = "10.42.1.0/24"
}
# Create private subnet two
resource "aws_subnet" "privatesub2" {
  vpc_id = aws_vpc.rodsvpc.id
  cidr_block = "10.42.2.0/24"
}
# Create public subnet one
resource "aws_subnet" "publicsub1" {
  vpc_id = aws_vpc.rodsvpc.id
  cidr_block = "10.42.3.0/24"
}
# Create public subnet two
resource "aws_subnet" "publicsub2" {
  vpc_id = aws_vpc.rodsvpc.id
  cidr_block = "10.42.4.0/24"
}


