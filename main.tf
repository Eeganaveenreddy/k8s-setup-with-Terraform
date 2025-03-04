# module "create-user" {
#   source = "./modules/IAM-USER"
# }

# # sleep 60s for to comeup VPC policies
# resource "time_sleep" "wait_for_vpc_policies" {
#   depends_on = [ module.iam-policy ]

#   create_duration = "90s"
# }

# data "aws_availability_zones" "available" {}

module "VPC" {
  source = "./modules/VPC"
  depends_on = [ module.iam-policy ]
}

# # sleep 60s for to comeup EC2 policies
# resource "time_sleep" "wait_for_ec2_policies" {
#   depends_on = [ module.VPC ]

#   create_duration = "30s"
# }

# module "EC2" {
#   source = "./modules/ec2"
#   vpc_id = module.VPC.MAIN_TF_VPC_ID
#   subnet_id = module.VPC.public_subnet_id-1
#   depends_on = [ module.VPC ]
# }

module "iam-policy" {
  source = "./modules/IAM-POLICY"
}

module "eks" {
  source = "./modules/EKS"
  subnet_ids = [module.VPC.public_subnet_id-1, module.VPC.public_subnet_id-2]
  eks_policy_attach = module.iam-policy
  role_arn = module.iam-policy.aws_eks_cluster_role_arn_out
  node_groups = var.node_groups
}

module "AWS-Ingress-loadbalancer" {
  source = "./modules/AWS-Ingress-loadbalancer"
  node_group_role_name = module.eks.node_group_role_name_output
  eks_cluster_name = module.eks.eks_cluster_name_output

  depends_on = [ module.eks ]
}
