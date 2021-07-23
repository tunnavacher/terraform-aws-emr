# AWS EMR cluster default role configuration
###################################################


resource "aws_iam_instance_profile" "emr_profile" {
  name = "emr_profile"
  role = aws_iam_role.iam_emr_profile_role.name
}

resource "aws_iam_role_policy" "iam_emr_profile_policy" {
  name = "iam_emr_profile_policy"
  role = aws_iam_role.iam_emr_profile_role.id
}

# AWS EMR cluster
resource "aws_emr_cluster" "emr_cluster" {
  count = var.enable_emr_cluster ? 1 : 0
  name  = "${local.name}" 
  description = "My Dev EMR test cluster"
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
    key_name                          = var.key_name
    subnet_id                         = var.subnetid            #### data.aws_subnet_ids.data.ids
    emr_managed_master_security_group = data.aws_security_group.default.id
    emr_managed_slave_security_group  = data.aws_security_group.default.id
    instance_profile                  = aws_iam_instance_profile.emr_profile.arn ##############################
  }
	
 master_instance_group {
    name           = "${local.name}-master_instace_group" 
    instance_type  = var.master_instance_group_instance_type
    instance_count = var.master_instance_group_instance_count
    #bid_price      = var.master_instance_group_bid_price

    ebs_config {
      size                 = var.master_instance_group_ebs_size
      type                 = var.master_instance_group_ebs_type
      volumes_per_instance = var.master_instance_group_ebs_volumes_per_instance
    }
  }
	
core_instance_group {
    name           = ${local.name}-core_instance_group
    instance_type  = var.core_instance_group_instance_type
    instance_count = var.core_instance_group_instance_count

    ebs_config {
      size                 = var.core_instance_group_ebs_size
      type                 = var.core_instance_group_ebs_type
      volumes_per_instance = var.core_instance_group_ebs_volumes_per_instance
    }

    #bid_price          = var.core_instance_group_bid_price
    autoscaling_policy = <<EOF
{
"Constraints": {
  "MinCapacity": 1,
  "MaxCapacity": 2
},
"Rules": [
  {
    "Name": "ScaleOutMemoryPercentage",
    "Description": "Scale out if YARNMemoryAvailablePercentage is less than 15",
    "Action": {
      "SimpleScalingPolicyConfiguration": {
        "AdjustmentType": "CHANGE_IN_CAPACITY",
        "ScalingAdjustment": 1,
        "CoolDown": 300
      }
    },
    "Trigger": {
      "CloudWatchAlarmDefinition": {
        "ComparisonOperator": "LESS_THAN",
        "EvaluationPeriods": 1,
        "MetricName": "YARNMemoryAvailablePercentage",
        "Namespace": "AWS/ElasticMapReduce",
        "Period": 300,
        "Statistic": "AVERAGE",
        "Threshold": 15.0,
        "Unit": "PERCENT"
      }
    }
  }
]
}
EOF
  }
  }

bootstrap_action {
    path = "s3://elasticmapreduce/bootstrap-actions/run-if"
    name = "runif"
    args = ["instance.isMaster=true", "echo running on master node"]
  }


resource "aws_emr_security_configuration" "security_configuration" {
  name = "emrsc"
  configuration = file("${path.module}/emr_configurations.json")
}
	
	
	
	
	
