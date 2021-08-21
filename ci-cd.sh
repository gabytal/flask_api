#!/usr/bin/env bash
version=$1
elk_host=$2
ecr_repo=$3

cd /home/ubuntu/flask_api/ &&
docker build -t flask-app:$version . &&
docker run -d --name flask-app -p 5000:5000 --env elk_host="$elk_host" flask-app:"$version" &&

chmod 555 test_api_functionality.sh

./test_api_functionallity.sh
if [ $? -eq 0 ]; then
    echo "the API is is fucntioning!"
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


