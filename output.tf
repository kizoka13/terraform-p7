output "vpc_id" {
  value = aws_vpc.splunk_vpc.id
}

output "sg_id" {
  value = aws_security_group.splunk_sg.id
}

output "ec2_public_ip" {
  value = aws_instance.splunk_instance.public_ip
}