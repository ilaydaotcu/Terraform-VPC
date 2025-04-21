 #What You Need to Create a VPC in Terraform ?
 #Think of a VPC as your own private network inside AWS. To make it usable, you need a few key components.

provider "aws" {
  region = var.aws_region
}

#🧱 1. VPC Block; This is the main "network container."

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "CutieVPC"
  }
}

#🧩 2. Subnets divide your VPC into smaller sections (public or private).

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = "CutiePublicSubnet"
  }
}

# 🌐 3. Internet Gateway (IGW) Required for public subnets to access the internet.

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "CutieIGW"
  }
}

#🧭 4. Route Table Controls how traffic flows — especially needed for internet access.

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "CutiePublicRT"
  }
}

#🌍 6. Route (Default Route to Internet) Let’s the subnet talk to the internet.

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}


#🚗 5. Route Table Association Connects your subnet to the route table.

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

#🧠 Optional Extras:

#Component	Use Case
#Private Subnet	For databases, apps not exposed to internet
#NAT Gateway	Give internet access to private subnet
#Security Groups	Control traffic in/out of EC2