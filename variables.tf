variable "emr_cluster_name" {
  description = "The name of the job flow"
  type        = string
  default     = ""
}

variable "release_label" {
  description = "(Required) The release label for the Amazon EMR release ["emr-5.29.0","emr-5.30.0","emr-5.30.1"]"
  type        = string
  default     = ""
}

variable "emr_cluster_service_role" {
  description = "(Required) IAM role that will be assumed by the Amazon EMR service to access AWS resources"
  type        = string
  default     = null
}

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

variable "emr_cluster_security_configuration" {
  description = "The security configuration name to attach to the EMR cluster."
  type        = string
  default     = null
}

variable "emr_cluster_log_uri" {
  description = "S3 bucket to write the log files of the job flow"
  type        = string
  default     = null
}

variable "emr_cluster_applications" {
  description = "S3 bucket to write the log files of the job flow"
  type        = string
  default     = ["Spark","Hive","Ganglia","Livy"]
}

variable "emr_cluster_termination_protection" {
  description = "Switch on/off termination protection"
  type        = bool
  default     = false
}

variable "emr_cluster_keep_job_flow_alive_when_no_steps" {
  description = "On/off when no steps or all steps are complete"
  type        = bool
  default     = true
}

variable "emr_cluster_ebs_root_volume_size" {
  description = "Size of the root volume"
  type        = number
  default     = 30
}

variable "emr_cluster_custom_ami_id" {
  description = "A custom Amazon Linux AMI for the cluster (instead of an EMR-owned AMI). Available in Amazon EMR version 5.7.0 and later"
  default     = null
}

variable "emr_cluster_visible_to_all_users" {
  description = "job flow is visible to all IAM users of the AWS account associated with the job flow. Default true"
  type        = bool
  default     = true
}
variable "emr_cluster_autoscaling_role" {
  description = "An IAM role for automatic scaling policies. The IAM role provides permissions that the automatic scaling feature requires to launch and terminate EC2 instances in an instance group."
  type        = string
  default     = null
}

variable "emr_cluster_step_concurrency_level" {
  description = "(Optional) The number of steps that can be executed concurrently. You can specify a maximum of 256 steps. Only valid for EMR clusters with release_label 5.28.0 or greater. (default is 1)"
  default     = 1
  type        = number
}

