# import requried modules
import os
from flask import Flask, request, jsonify
from datetime import datetime, date, time, timezone
from elasticsearch import Elasticsearch
from marshmallow import Schema, fields, ValidationError
import json

   
class BaseSchema(Schema):
    log_type = fields.String(required=True)
    message = fields.String(required=True)
    version = fields.Integer(required=True)

# set ElasticSearch host
client = Elasticsearch(hosts=[os.environ['elk_host']])

app = Flask('flaskapp')

# set the proper GET endpoint
@app.route('/logs', methods=["POST"])
def index():
     # Get Request body from JSON
    request_data = request.json
    schema = BaseSchema()
    try:
        # Validate request body against schema data types
        result = schema.load(request_data)
    except ValidationError as err:
        # Return a nice message if validation fails
        result = False
        return jsonify(err.messages), 400
    
    if result:
        product = request.args.get('product')
        json_element = {'product': product}
    
        # send the json to elastic using Elastic python module
        try:
            response = client.index(index='api-index', doc_type='_doc', body=json_element)
        except Exception as e:
            return f'Error sending index to elastic search. {e}'

        return json_element

if __name__ == '__main__':
    app.run(host='0.0.0.0')
