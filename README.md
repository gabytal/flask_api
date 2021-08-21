# flask_api

# Debugging:
ubuntu@ip-10-0-0-135:~/flask_api$ sudo docker logs flask-app --follow
[2021-08-21 21:25:51,430] DEBUG - Setting ES host: vpc-gaby-es-5oa4pfc6gmxo7j4m7tpejqi7gi.us-east-1.es.amazonaws.com
 * Serving Flask app "flaskapp" (lazy loading)
 * Environment: production
   WARNING: This is a development server. Do not use it in a production deployment.
   Use a production WSGI server instead.
 * Debug mode: off
[2021-08-21 21:25:51,437] INFO -  * Running on http://0.0.0.0:5000/ (Press CTRL+C to quit)
[2021-08-21 21:26:26,535] DEBUG - Validating request body
[2021-08-21 21:26:26,535] INFO - Request body validations has passed!
[2021-08-21 21:26:26,536] DEBUG - Preparing data for ES
[2021-08-21 21:26:26,536] DEBUG - Sending data for ES: {'log_type': 'xyz', 'message': 'sdahasdh', 'version': 1}
[2021-08-21 21:26:26,537] DEBUG - Starting new HTTP connection (1): vpc-gaby-es-5oa4pfc6gmxo7j4m7tpejqi7gi.us-east-1.es.amazonaws.com:80
[2021-08-21 21:26:26,843] DEBUG - http://vpc-gaby-es-5oa4pfc6gmxo7j4m7tpejqi7gi.us-east-1.es.amazonaws.com:80 "POST /api-index/_doc HTTP/1.1" 201 176
[2021-08-21 21:26:26,844] INFO - POST http://vpc-gaby-es-5oa4pfc6gmxo7j4m7tpejqi7gi.us-east-1.es.amazonaws.com:80/api-index/_doc [status:201 request:0.307s]
[2021-08-21 21:26:26,844] DEBUG - > {"log_type":"xyz","message":"sdahasdh","version":1}
[2021-08-21 21:26:26,844] DEBUG - < {"_index":"api-index","_type":"_doc","_id":"kkCbansBQ2qqlU0ElltR","_version":1,"result":"created","_shards":{"total":2,"successful":1,"failed":0},"_seq_no":1,"_primary_term":1}
[2021-08-21 21:26:26,845] INFO - Data successfully sent to ES!
[2021-08-21 21:26:26,846] INFO - 172.17.0.1 - - [21/Aug/2021 21:26:26] "POST /logs HTTP/1.1" 200 -
