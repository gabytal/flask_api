#!/bin/bash
# this script purpose is to test the API, by sending get request and expect 200 Status Code.

# sending a POST request and exporting the status code
status_code=$(curl -H "Content-Type: application/json" -X POST  -d '{"log_type":"CI_TEST", "message": "CI_TEST", "version": 1}' --write-out "%{http_code}"  http://localhost:4500/logs)

if test "$status_code" -ne 200; then
    echo "Response status code: $status_code"
    echo "there is a problem with API, please check!"
    exit 1
else
    echo "Response status code: $status_code"
    echo "The API is OK!"
fi
