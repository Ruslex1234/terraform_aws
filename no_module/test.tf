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
# Create NAT gateway one
resource "aws_nat_gateway" "natgatewayone" {
  subnet_id     = aws_subnet.privatesub1.id
}
# Create NAT gateway two
resource "aws_nat_gateway" "natgatewaytwo" {
  subnet_id     = aws_subnet.privatesub2.id
}
# Create Internet gateway one
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.rodsvpc.id
}
# Create route table private one
resource "aws_route_table" "privateroutetableone" {
  vpc_id = aws_vpc.rodsvpc.id
  route {
    cidr_block = "10.42.1.0/24"
    gateway_id = "natgatewayone"
  }

}

