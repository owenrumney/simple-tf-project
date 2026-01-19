variable "instance_type" {
  default = "wrong"
}

resource "aws_instance" "example" {
  instance_type = var.instance_type
}
