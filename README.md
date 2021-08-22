##  Application Layer
* Docker container
    * Python 3.9 Docker image
      * Python Modules:
        * Flask 1.1.4 - for the API
        * elasticsearch 7.7.0 - for Log shipping to ELK
        * marshmallow 3.13.0 - for request data validations
        

## API Features:
  * supports POST requests
    * supported data type: application/json
    supported keys:
      * "log_type": STR
      + "message": STR
      * "version": INT
    
      
  * Advance API Application Logging
  * Logs can be viewed through container logs 


# Debugging:
      curl -H "Content-Type: application/json" -X POST  -d '{"log_type":"CI_TEST", "message": "CI_TEST", "version": 1}' http://localhost:5000/logs
      {"log_type":"CI_TEST","message":"CI_TEST","version":1}
