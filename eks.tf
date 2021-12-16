data "aws_eks_cluster" "myapp-eks-cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "myapp-eks-cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.myapp-eks-cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.myapp-eks-cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.myapp-eks-cluster.token
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"

  cluster_version = "1.21"
  cluster_name    = "myapp-eks-cluster"
  vpc_id          = module.myapp-vpc.vpc_id
  subnets         = module.myapp-vpc.private_subnets

  tags ={
      environemnt="dev"
      application="myapp"
  }
  worker_groups = [
    {
      instance_type = "t2.medium"
      name="worker-group-1"
      asg_max_size  = 2
    },
    {
      instance_type = "t2.small"
      name="worker-group-2"
      asg_max_size  = 1 
    }
  ]
}