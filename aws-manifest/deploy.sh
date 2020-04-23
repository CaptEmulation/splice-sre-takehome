#!/bin/bash
# from https://aws.amazon.com/blogs/devops/set-up-a-build-pipeline-with-jenkins-and-amazon-ecs/
#  - updated json egrep searches to jq

SERVICE_NAME="spliceSreTakehome-ecs-service"
IMAGE_VERSION=${BUILD_NUMBER}
TASK_FAMILY="spliceSreTakehome"

# Create a new task definition for this build
sed -e "s;%BUILD_NUMBER%;${BUILD_NUMBER};g" spliceSreTakehome.json > spliceSreTakehome-${BUILD_NUMBER}.json
aws ecs register-task-definition --family spliceSreTakehome --cli-input-json file://spliceSreTakehome-${BUILD_NUMBER}.json

# Update the service with the new task definition and desired count
TASK_REVISION=`aws ecs describe-task-definition --task-definition spliceSreTakehome | jq -e ".taskDefinition.revision"`
DESIRED_COUNT=`aws ecs describe-services --services ${SERVICE_NAME} | jq -e ".taskDefinition.desiredCount"`
if [ ${DESIRED_COUNT} = "0" ]; then
    DESIRED_COUNT="1"
fi

aws ecs update-service --cluster default --service ${SERVICE_NAME} --task-definition ${TASK_FAMILY}:${TASK_REVISION} --desired-count ${DESIRED_COUNT}