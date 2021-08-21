#!/usr/bin/env bash
cd /home/ubuntu/ &&
git clone https://github.com/gabytal/flask_api.git &&
cd flask_api/ &&
docker build -t flask-app:$1 . &&
docker run -d --name flask-app -p 5000:5000 --env elk_host="$2" flask-app:"$1"
cd .. && rm -Rf flask_api/
docker image prune -a --force

echo "OK"
