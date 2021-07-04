# AWS EMR cluster
resource "aws_emr_cluster" "emr_cluster" {
  name          = var.emr_cluster_name
  release_label = var.release_label
  service_role  = var.emr_cluster_service_role
  
  security_configuration            = var.emr_cluster_security_configuration
  log_uri                           = var.emr_cluster_log_uri
  applications                      = var.emr_cluster_applications
  termination_protection            = var.emr_cluster_termination_protection
  keep_job_flow_alive_when_no_steps = var.emr_cluster_keep_job_flow_alive_when_no_steps
  ebs_root_volume_size              = var.emr_cluster_ebs_root_volume_size
  custom_ami_id                     = var.emr_cluster_custom_ami_id
  configurations_json               = file("${path.module}/emr_configurations.json")
  visible_to_all_users              = var.emr_cluster_visible_to_all_users
  autoscaling_role                  = var.emr_cluster_autoscaling_role
  step_concurrency_level            = var.emr_cluster_step_concurrency_level
	

ec2_attributes {
    subnet_id                         = var.subnetid
    emr_managed_master_security_group = data.aws_security_group.default.id
    emr_managed_slave_security_group  = data.aws_security_group.default.id
    instance_profile                  = aws_iam_instance_profile.emr_profile.arn
  }

instance_groups = [
    {
      name           = "MasterInstanceGroup"
      instance_role  = "MASTER"
      instance_type  = "m3.xlarge"
      instance_count = "1"
    },
    {
      name           = "CoreInstanceGroup"
      instance_role  = "CORE"
      instance_type  = "m3.xlarge"
      instance_count = "1"
      bid_price      = "0.30"
    },
  ]














resource "aws_emr_cluster" "cluster" {
  name          = "emr-test-arn"
  release_label = ["emr-5.29.0","emr-5.30.0","emr-5.30.1"]
  applications  = ["Spark","Hive","Ganglia","Livy"]
  
   emr_cluster_master_instance_group = [
    {
      instance_type  = "m4.large"
      instance_count = 1

      ebs_config = {
        size                 = 10
        type                 = "gp2"
        volumes_per_instance = 1
      }
    }
  ]
  
   emr_cluster_core_instance_group = [
    {
      instance_type  = "c4.large"
      instance_count = 1
      # bid_price                       = "1.30"
      autoscaling_policy = file("./additional_files/emr-cluster-core_instance_group-autoscaling_policy.json")

      ebs_config = {
        size                 = 10
        type                 = "gp2"
        volumes_per_instance = 1
      }
    }
  ]
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  bootstrap_action {
    path = "s3://elasticmapreduce/bootstrap-actions/run-if"
    name = "runif"
    args = ["instance.isMaster=true", "echo running on master node"]
  }
  
  "BootstrapActions": [
                    {
                        "Name": "InstallBootstrap",
                        "ScriptBootstrapAction": {
                            "Args": [],
                            "Path": { "Fn::Join" : ["" , ["s3://gf-us-",{"Ref" : "Environment"} ,"-mfg-cloudops-infy/emr/emr-5.30/bootstrap/scripts/EMR_Bootstrap_pip.sh" ]] }
                        }
                    },
					{
                        "Name": "CopyJarBootstrap",
                        "ScriptBootstrapAction": {
                            "Args": [],
							"Path": { "Fn::Join" : ["" , ["s3://gf-us-",{"Ref" : "Environment"} ,"-mfg-cloudops-infy/emr/emr-5.30/bootstrap/scripts/EMR_Bootstrap_Onlyonmaster.sh" ]] }
                        }
                    }
                ],
  master_instance_group {
    instance_type = "m4.large"
  }

  core_instance_group {
    instance_type  = "c4.large"
    instance_count = 1

    ebs_config {
      size                 = "40"
      type                 = "gp2"
      volumes_per_instance = 1
    }
