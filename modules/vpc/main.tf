terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

# -------------------------------
# VPC
# -------------------------------
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(var.tags, {
    Name = "${var.project_name}-vpc"
  })
}

# -------------------------------
# Public Subnets
# -------------------------------
resource "aws_subnet" "public" {
  for_each = {
    for idx, az in toset(var.availability_zones) : idx => az
  }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[tonumber(each.key)]
  availability_zone       = each.value
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.project_name}-public-${each.value}"
    Tier = "public"
  })
}

# -------------------------------
# Private Subnets
# -------------------------------
resource "aws_subnet" "private" {
  for_each = {
    for idx, az in toset(var.availability_zones) : idx => az
  }

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidrs[tonumber(each.key)]
  availability_zone = each.value

  tags = merge(var.tags, {
    Name = "${var.project_name}-private-${each.value}"
    Tier = "private"
  })
}

# -------------------------------
# Internet Gateway
# -------------------------------
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.project_name}-igw"
  })
}

# -------------------------------
# NAT Gateways (one per AZ)
# -------------------------------
resource "aws_eip" "nat" {
  for_each = aws_subnet.public
  domain   = "vpc"

  tags = merge(var.tags, {
    Name = "${var.project_name}-eip-${each.key}"
  })
}

resource "aws_nat_gateway" "this" {
  for_each      = aws_subnet.public
  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = each.value.id
  depends_on    = [aws_internet_gateway.this]

  tags = merge(var.tags, {
    Name = "${var.project_name}-nat-${each.key}"
  })
}

# -------------------------------
# Route Tables & Associations
# -------------------------------
## Public RT
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags = merge(var.tags, {
    Name = "${var.project_name}-public-rt"
  })
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public_assoc" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

## Private RT (one per AZ with NAT)
resource "aws_route_table" "private" {
  for_each = aws_nat_gateway.this
  vpc_id   = aws_vpc.this.id
  tags = merge(var.tags, {
    Name = "${var.project_name}-private-rt-${each.key}"
  })
}

resource "aws_route" "private_nat" {
  for_each               = aws_nat_gateway.this
  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = each.value.id
}

resource "aws_route_table_association" "private_assoc" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}
