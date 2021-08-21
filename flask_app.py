        
# import required modules
import os
from flask import Flask, request, jsonify
from elasticsearch import Elasticsearch
from marshmallow import Schema, fields, ValidationError


class BaseSchema(Schema):
    log_type = fields.String(required=True)
    message = fields.String(required=True)
    version = fields.Integer(required=True)


# set ElasticSearch host
client = Elasticsearch(hosts=[f'{os.environ["elk_host"]}:80'])

app = Flask('flaskapp')


# set the proper GET endpoint
@ app.route('/logs', methods=["POST"])
def index():
    # Get Request body from JSON
    request_data = request.json
    schema = BaseSchema()

    result = False
    try:
        # Validate request body against schema data types
        result = schema.load(request_data)
    except ValidationError as err:
        # Return a nice message if validation fails
        return jsonify(err.messages), 400

    if result:
        json_element = {'log_type': request_data['log_type'],
                        'message': request_data['message']
                       'version': request_data['version']}
        # send the json to elastic using Elastic python module
        try:
            response = client.index(index='api-index', doc_type='_doc', body=json_element, request_timeout=15)
        except Exception as e:
            return f'Error sending index to elastic search. {e}'
        return json_element

if __name__ == '__main__':
    app.run(host='0.0.0.0')
