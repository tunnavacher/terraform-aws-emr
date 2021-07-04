data "aws_vpc" "default"{
filter{
 name = "tag:Name"
values = ["nyl-${var.lob}-${var.env}-vpc"]
}
}

data "aws_subnet_ids" "data"{
vpc_id = data.aws_vpc.default.id
  tags={
 tier ="data"
}
}

data "aws_security_group" "default"{
name = "nyl-${var.lob}-${var.env}-vpc-access-sg"]
}
