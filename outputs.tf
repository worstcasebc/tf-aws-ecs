output "aws_region" {
  value = var.AWS_REGION
}

output "my-own-ip" {
  value = format("%s/32", chomp(data.http.icanhazip.body))
}

output "bastion-host-ssh" {
  value = format("ssh -A ec2-user@%s", aws_instance.bastionhost.public_ip)
}
