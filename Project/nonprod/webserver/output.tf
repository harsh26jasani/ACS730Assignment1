# Step 10 - Add output variables
output "public_ip" {
  value = aws_instance.bastion.public_ip
}

output "bastion_sg" {
  value = aws_security_group.bastion_sg.id
}


output "private_ip_1" {
  value = aws_instance.Webserver_1.private_ip
}


output "private_ip_2" {
  value = aws_instance.Webserver_2.private_ip
}