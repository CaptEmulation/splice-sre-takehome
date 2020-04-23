resource "aws_launch_configuration" "ecs-launch-configuration" {
    name                        = "ecs-launch-configuration"
    image_id                    = "ami-fad25980"
    instance_type               = "t3.small"
    iam_instance_profile        = aws_iam_instance_profile.ecs-instance-profile.id

    root_block_device {
      volume_type = "standard"
      volume_size = 100
      delete_on_termination = true
    }

    lifecycle {
      create_before_destroy = true
    }

    security_groups             = ["${aws_security_group.spliceSreTakehome.id}"]
    associate_public_ip_address = "true"
    user_data                   = <<EOF
                                  #!/bin/bash
                                  echo ECS_CLUSTER=${var.ecs_cluster} >> /etc/ecs/ecs.config
                                  EOF
}