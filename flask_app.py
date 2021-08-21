# import requried modules
import os
from flask import Flask, request, jsonify
from datetime import datetime, date, time, timezone
from elasticsearch import Elasticsearch
import json

elk_host = os.environ['elk_host']
password = os.environ['MY_PASS']
print("Running with user: %s" % username)
app = Flask('flaskapp')


# set the proper GET endpoint
@app.route('/tracking', methods=["POST"])

# convert data to JSON format
def index(product=""):
    json_element = {'product': product}
    
    # set ElasticSearch host
    client = Elasticsearch(hosts=["http://elk_host:80"])
    
    # send the json to elastic using Elastic python module
    try:
        response = client.index(index='api-index', doc_type='_doc', body=json_element)
    except Exception as e:
        return f'Error sending index to elastic search. {e}'
    
    return json_element

if __name__ == '__main__':
    app.run(host='0.0.0.0')
