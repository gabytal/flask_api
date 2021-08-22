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
  * Application Log shipping ability to ELK cluster


---

### CI-CD Process 
### Pipeline stages:
 * Clone Git Repo
 * Build new docker image
 * Test the API
 * Push Artifact version at ECR Repo  
 * Deploy the Artifact to the production server

###Usage
#### This process needs to be executed each time a new version of the API is ready.
in a better world, this ci-cd script will be replaced with a Jenkins pipeline.

1. Get CI Machine IP from Terraform
   ```sh
   ci_machine = $(terraform output ci-prod-machine-ip)
   ```
2. SSH to the CI machine 
   ```sh
   ssh ubuntu@$ci_machine -i ~.ssh/private_key
   ```
3. Configure AWS Credentials (needed to Push the Artifact to ECR)
   ```sh
   aws configure
   ```
      
3. Clone the Flask-API GitHub Repo to the CI machine
   ```sh
    git clone https://github.com/gabytal/flask_api.git
    cd flask_api/
   ```
4. Set permissions to the required files
   ```sh
     chmod 555 ci-cd.sh test_api_functionality.sh
   ```
5. Execute the ci-cd.sh script.
    ```sh
    sudo./ci-cd.sh <VERSION> <ELK_HOST> <ECR_REPO>
    ```
       

# Debugging Prod Server:
      curl -H "Content-Type: application/json" -X POST  -d '{"log_type":"CI_TEST", "message": "CI_TEST", "version": 1}' http://localhost:5000/logs
      {"log_type":"CI_TEST","message":"CI_TEST","version":1}
