locals {
 name ="nyl-${var.lob}-${var.env}-${var.application}-${var.emr_cluster}
}

data "aws_ami" "ami_os_type"{
filter{
 name = "tag:Name"
 values = ["${var.lob}-${var.env}-amzlinux2
}
}

data "aws_vpc" "default"{
filter{
 name = "tag:Name"
 values = ["nyl-${var.lob}-${var.env}-vpc"]
}
}

data "aws_subnet_ids" "data" {
    vpc_id = data.aws_vpc.this.id

    tags={
        tier = "compute"
    }
}

data "aws_subnet" "compute" {
for_each = data.aws_subnet_ids.data.ids
id =each.value
}

data "aws_security_group" "default"{
name = "nyl-${var.lob}-${var.env}-vpc-access-sg"]
}
