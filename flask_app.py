# import required modules
import os
from flask import Flask, request, jsonify
from elasticsearch import Elasticsearch
from marshmallow import Schema, fields, ValidationError
import logging

# configure logging
logs_format = '[%(asctime)s] %(levelname)s - %(message)s'
logger = logging.getLogger()

es_host = os.environ['elk_host']

# this is needed in order to see the logs through docker logs
# '/proc/1/fd/1' file is functioning as the Pod's STDOUT.
handler = logging.FileHandler('/proc/1/fd/1', mode='w')
logger.setLevel(logging.DEBUG)
formatter = logging.Formatter(logs_format)
handler.setFormatter(formatter)
logger.addHandler(handler)


class BaseSchema(Schema):
    log_type = fields.String(required=True)
    message = fields.String(required=True)
    version = fields.Integer(required=True)


# set ElasticSearch host
logger.debug(f"Setting ES host: {es_host}")
client = Elasticsearch(hosts=[f"{es_host}:80"])

if not client.ping():
    logger.error("Could not connect to Elastic Search!, please investigate")
    os.sys.exit(1)

app = Flask('flaskapp')


# set the proper GET endpoint
@app.route('/logs', methods=["POST"])
def index():
    # Get Request body from JSON
    request_data = request.json

    # set the input schema
    schema = BaseSchema()

    result = False
    try:
        # Validate request body against schema data types
        logger.debug("Validating request body")
        result = schema.load(request_data)
    except ValidationError as err:
        # Return a nice message if validation fails
        logger.error("Request body validations has faild!")
        return jsonify(err.messages), 400

    if result:
        logger.info("Request body validations has passed!")
        logger.debug("Preparing data for ES")
        json_element = {'log_type': request_data['log_type'],
                        'message': request_data['message'],
                        'version': request_data['version']}
        # send the json to elastic using Elastic python module
        try:
            logger.debug(f"Sending data for ES: {json_element}")
            response = client.index(index='api-index', doc_type='_doc', body=json_element, request_timeout=15)
        except Exception as e:
            logger.error("Could not send data to ES!")
            return f'Error sending index to elastic search. {e}'
        if response:
            logger.info("Data successfully sent to ES!")
        return json_element


if __name__ == '__main__':
    app.run(host='0.0.0.0')
