module "eks_cluster" {
  source = "./modules/eks-cluster"
}

module "clipo" {
  source            = "./modules/clipo"
  clipo_db_username = var.clipo_db_username
  clipo_db_password = var.clipo_db_password
}

module "users" {
  source            = "./modules/users"
  users_db_username = var.users_db_username
  users_db_password = var.users_db_password
}