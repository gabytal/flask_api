
#import requried modules
import os
from flask import Flask, request, jsonify
from ip2geotools.databases.noncommercial import DbIpCity
from datetime import datetime, date, time, timezone
from elasticsearch import Elasticsearch
import json
    
elk_host = os.environ['elk_host']
password = os.environ['MY_PASS']
print("Running with user: %s" % username)  
app = Flask('flaskapp')

#set the proper GET endpoint
@app.route('/tracking', methods=["POST"])

    #convert data to JSON format
    json_element={}
    json_element['product']=product

    #set ElasticSearch host
    client = Elasticsearch(hosts=["http://elk_host:80"])
    
    #send the json to elastic using Elastic python module
    try:
        response = client.index( index = 'my_index', doc_type = '_doc',   body = json_element )   
    except Exception:
            return ('Error sending index to elastic search')
    
    return json_element
     
if __name__ == '__main__':
    app.run(host='0.0.0.0') 
