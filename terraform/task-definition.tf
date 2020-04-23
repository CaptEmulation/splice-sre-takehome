data "aws_ecs_task_definition" "spliceSreTakehome" {
  task_definition = aws_ecs_task_definition.spliceSreTakehome.family
}

resource "aws_ecs_task_definition" "spliceSreTakehome" {
    family                = "spliceSreTakehome"
    container_definitions = <<DEFINITION
[
  {
    "name": "http-hello-world",
    "image": "strm/helloworld-http",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ],
    "memory": 500,
    "cpu": 10
  }
]
DEFINITION
}