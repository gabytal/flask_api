#!/usr/bin/env bash
# This is a CI\CD script that: Clone, Build, Test, Save Artifact version at ECR Rrepo & Deploy the Artifact to the production server2.
# Usage:
# 1. git clone https://github.com/gabytal/flask_api.git
# 2. cd flask_api/
# 3. chmod 555 ci-cd.sh test_api_functionality.sh
# 4. sudo ./ci-cd.sh <APP_VERSION> <ELASTIC_SEARCH_ENDPOINT> <ECR_REPO> \\
#  Example: sudo./ci-cd.sh 1.0 vpc.us-east-1.es.amazonaws.com 806.dkr.ecr.us-east-1.amazonaws.com/flask_app

version=$1
elk_host=$2
ecr_repo=$3

cd /home/ubuntu/flask_api/ &&
docker build --no-cache -t flask-app:"$version" . &&
if [ $? -eq 0 ]; then
    echo
    echo "A new Docker image has built - flask-app:$version"
    echo

else
    echo
    echo "There was a problem to build Dockerfile, please investigate"
    echo
    exit 1
fi

echo
echo "running Application container for testing" &&
echo

rm -f flask-app-test
docker run -d --name flask-app-test -p 4500:5000 --env elk_host="$elk_host" flask-app:"$version" &&
if [ $? -eq 0 ]; then
    echo
    echo "Application container for testing has been created"
    echo

else
    echo
    echo "Application container for testing has not been created, please investigate"
    echo

    exit 1
 fi


# wait for the API to start
sleep 10


# execute functional tests
./test_api_functionality.sh
if [ $? -eq 0 ]; then
    echo
    echo
    echo "the API is fucntioning!"
    echo

else
    echo
    echo "There was a problem with the API, please investigate"
    echo
    exit 1
fi


echo "CI Process has been passed for "$version""
echo
echo
echo "Pushing Atrifact: flask-app:"$version" to ECR."

eval $(aws ecr get-login --no-include-email --region=us-east-1)
if [ $? -eq 0 ]; then
    echo
    echo "Successfully login to ECR Repo!"
    echo

else
    echo
    echo "There was a problem with the connection to the ECR REPO. please investigate"
    echo
    exit 1
fi


docker tag flask-app:"$version" "$ecr_repo":"$version"

echo
echo "Pushing image to ECR..."
echo
docker push "$ecr_repo":"$version"
if [ $? -eq 0 ]; then
    echo
    echo "Api Version "$version" has been pushed to ECR Repo!"
    echo
else
    echo
    echo "There was a problem with the connection to the ECR REPO. please investigate"
    echo
    exit 1
fi



# clean ci env
echo "Cleaning Testing Enviornment."
docker image prune -a --force
cd .. && rm -Rf flask_api/
docker rm -f flask-app-test



# Deploying the tested version
echo
echo "Deploying version "$version" to production env"
echo


# Production Env demonstrated locally
echo
echo "Remove existing container..."
echo
docker rm -f flask-app
if [ $? -eq 0 ]; then
    echo
    echo "Prod container been deleted"
    echo
else
    echo
    echo "Prod container could not be deleted, please investigate"
    echo
    exit 1
 fi

echo
echo "creating new container...."
echo
docker run -d --name flask-app -p 5000:5000 --env elk_host="$elk_host" flask-app:"$version"
if [ $? -eq 0 ]; then
    echo
    echo "Application container been created with version "$version" "
    echo

else
    echo
    echo "Application container for testing has not been created, please investigate"
    echo

    exit 1
 fi

echo "The API Server is ON"
# USAGE:
# curl -H "Content-Type: application/json" -X POST  -d '{"log_type":"asdgyz", "message": "test5555", "version": 11}' http://localhost:5000/logs
# {"log_type":"asdgyz","message":"test5555","version":11}"



