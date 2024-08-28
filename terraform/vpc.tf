resource "aws_vpc" "cmw_vpc" {
  cidr_block = "10.100.0.0/16"

  tags = {
    Name = "CMW_VPC"
  }
}

resource "aws_subnet" "cmw_web_subnet" {
  count = 3

  vpc_id = aws_vpc.cmw_vpc.id
  cidr_block = cidrsubnet(aws_vpc.cmw_vpc.cidr_block, 8, count.index)
  availability_zone = var.AVAILABILITY_ZONES[count.index]

  tags = {
    Name = "cmw_web_subnet_${count.index}"
  }
}

resource "aws_subnet" "cmw_db_subnet" {
  count = 3

  vpc_id = aws_vpc.cmw_vpc.id
  cidr_block = cidrsubnet(aws_vpc.cmw_vpc.cidr_block, 8, 4 + count.index)
  availability_zone = var.AVAILABILITY_ZONES[count.index]

  tags = {
    Name = "cmw_db_subnet_${count.index}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.cmw_vpc.id
}

resource "aws_route_table" "cmw_web_route_table" {
  vpc_id = aws_vpc.cmw_vpc.id

  route {
    cidr_block = "0.0.0.0/0" 
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "CMW_Web_Route_Table"
  }
}

resource "aws_route_table_association" "cmw_web_rt_association" {
  count = 3

  subnet_id = aws_subnet.cmw_web_subnet[count.index].id
  route_table_id = aws_route_table.cmw_web_route_table.id
}

