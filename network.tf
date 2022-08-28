module "vpc" {
  source          = "terraform-aws-modules/vpc/aws"
  version         = "3.14.2"
  name            = "${var.system_name}-${var.env}-vpc"
  cidr            = "10.0.0.0/16"
  azs             = ["${local.region}a", "${local.region}c"]
  public_subnets  = ["10.0.0.0/24"]
  private_subnets = ["10.0.1.0/24"]
  tags            = local.tags
}

resource "aws_vpc_endpoint" "this" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.ap-northeast-1.s3"
  vpc_endpoint_type = "Gateway"
  tags              = local.tags
}

resource "aws_vpc_endpoint_route_table_association" "this" {
  route_table_id  = module.vpc.private_route_table_ids[0]
  vpc_endpoint_id = aws_vpc_endpoint.this.id
}
