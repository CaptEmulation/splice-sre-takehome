resource "aws_ecs_service" "spliceSreTakehome-ecs-service" {
  name            = "spliceSreTakehome-ecs-service"
  iam_role        = aws_iam_role.ecs-service-role.name
  cluster         = aws_ecs_cluster.test-ecs-cluster.id
  task_definition = "${aws_ecs_task_definition.spliceSreTakehome.family}:${aws_ecs_task_definition.spliceSreTakehome.revision}"
  desired_count   = 2

  load_balancer {
    target_group_arn  = aws_alb_target_group.ecs-target-group.arn
    container_port    = 80
    container_name    = "http-hello-world"
	}
}