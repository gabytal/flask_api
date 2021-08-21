# This is a CI\CD script that: Clone, Build, Test, Save Artifac & Deploy Artifact.
# Usage: 
# 1. git clone https://github.com/gabytal/flask_api.git
# 2. cd flask_api/
# 3. chmod 555 ci-cd.sh test_api_functionality.sh
# 4. sudo ./ci-cd.sh <APP_VERSION> <ELASTIC_SEARCH_ENDPOINT> <ECR_REPO> \\
#  Example: sudo./ci-cd.sh 1.0 vpc.us-east-1.es.amazonaws.com 806.dkr.ecr.us-east-1.amazonaws.com/docker

#!/usr/bin/env bash
version=$1
elk_host=$2
ecr_repo=$3

cd /home/ubuntu/flask_api/ &&
docker build -t flask-app:$version . &&
if [ $? -eq 0 ]; then
    echo "A new Docker image has built - flask-app:$version"
else
    echo "There was a problem to build Dockerfile, please investigate"
    exit 1
fi


echo "running Application container for testing" && 
docker run -d --name flask-app -p 5000:5000 --env elk_host="$elk_host" flask-app:"$version" &&
if [ $? -eq 0 ]; then
    echo "Application container for testing has been created"
else
    echo "Application container for testing has not been created, please investigate"
    exit 1
    
  
# wait for the API to start
sleep 10


# execute functional tests
./test_api_functionality.sh
if [ $? -eq 0 ]; then
    echo "the API is fucntioning!"
else
    echo "There was a problem with the API, please investigate"
    exit 1
fi


echo "CI Process has been passed."
echo "Pushing Atrifact - flask-app:"$version" to ECR."

docker login "$ecr_repo"
docker push flask-app:"$version"
docker image prune -a --force

# clean env
echo "Cleaning Testing Enviornment."
cd .. && rm -Rf flask_api/
docker rm -f flask-app


