resource "aws_alb" "ecs-load-balancer" {
    name                = "ecs-load-balancer"
    security_groups     = ["${aws_security_group.spliceSreTakehome.id}"]
    subnets             = ["${aws_subnet.spliceSreTakehome_1.id}", "${aws_subnet.spliceSreTakehome_2.id}"]
}

resource "aws_alb_target_group" "ecs-target-group" {
    name                = "ecs-target-group"
    port                = "80"
    protocol            = "HTTP"
    vpc_id              = aws_vpc.spliceSreTakehome.id

    health_check {
        healthy_threshold   = "5"
        unhealthy_threshold = "2"
        interval            = "30"
        matcher             = "200"
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = "5"
    }
}

resource "aws_alb_listener" "alb-listener" {
    load_balancer_arn = aws_alb.ecs-load-balancer.arn
    port              = "8080"
    protocol          = "HTTP"

    default_action {
        target_group_arn = aws_alb_target_group.ecs-target-group.arn
        type             = "forward"
    }
}