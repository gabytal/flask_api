#!/bin/bash
# this script purpose is to test the API, by sending get request and expect 200 Status Code.

# sending a POST request and exporting the status code
status_code=$(curl -k --silent --output /dev/null --write-out "%{http_code}" https://localhost/logs?12124)

if test "$status_code" -ne 200; then
    echo "Response status code: $status_code"
    echo "there is a problem with API, please check!"
    exit 2
else
    echo "Response status code: $status_code"
    echo "The API is OK!"
fi
