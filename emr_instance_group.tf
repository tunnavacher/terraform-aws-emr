resource "aws_emr_instance_group" "emr_instance_group" {
  name          = var.emr_instance_group_name
  cluster_id    = aws_emr_cluster.emr_cluster.id
  instance_type = var.emr_instance_group_instance_type

  instance_count      = var.emr_instance_group_instance_count
  ebs_config {
      size                 = "40"
      type                 = "gp2"
      volumes_per_instance = 1
    }
  
