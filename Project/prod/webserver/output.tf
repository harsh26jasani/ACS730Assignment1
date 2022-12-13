#Adding output variables
output "private_ip_1" {
  value = aws_instance.Webserver_Prod_1.private_ip
}

output "private_ip_2" {
  value = aws_instance.Webserver_Prod_2.private_ip
}
