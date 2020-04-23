resource "aws_autoscaling_group" "ecs-autoscaling-group" {
    name                        = "${aws_launch_configuration.ecs-launch-configuration.name}-asg"
    max_size                    = var.max_instance_size
    min_size                    = var.min_instance_size
    desired_capacity            = var.desired_capacity
    vpc_zone_identifier         = ["${aws_subnet.spliceSreTakehome_1.id}", "${aws_subnet.spliceSreTakehome_2.id}"]
    launch_configuration        = aws_launch_configuration.ecs-launch-configuration.name
    health_check_type           = "ELB"
    force_delete = true

    lifecycle {
      create_before_destroy = true
    }
  }