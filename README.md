# Splice takehome assignment

Implements a terraform + Jenkins build and deploy process

Running at: http://ecs-load-balancer-1478987943.us-east-1.elb.amazonaws.com:8080/

# Limitations

Developed against a local Jenkins instance with pre-configured AWS CLI

Terraform is an infrastructure tool rather than a deployment tool. Performing deployments with terraform can lead to downtime.

My preferred deployment platform is Kubernetes, though here we show using AWS CLI directly to update the task definition on ECS. It was far more annoying that I expected. I wish I had just gone ahead and spun up a k8s cluster and that part would have easier for me.

I put in a quick hack to use the AWS CLI to update the task definition of the ECS service. So the lifecycle process is to spin up all resources from terraform once, and then use the build script to just update the service. The problem with that process is that if in the future terraform is run again against the same resources, it will have to recreate ECS resources because they will have gone out of sync with state. At this point I ran out of time. Would have liked more time to clean that up some with some of the pointers I read online or transition to deploying less the terraform and let the build process manage deployments entirely.

