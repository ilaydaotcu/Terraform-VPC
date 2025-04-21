output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "route_table_id" {
  value = aws_route_table.public_rt.id
}
