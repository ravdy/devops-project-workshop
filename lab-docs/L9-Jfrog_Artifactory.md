## Publsh jar file onto Jfrog Artifactory
1. Create artifactory account  
2. generate an access token  with username  (username must be your email id)
3. add username and password under jenkins credentials   
4. install artifactory plugin  
5. Update Jenkinsfile with jar publish step   
    ```sh 
         def registry = 'https://valaxy01.jfrog.io'
             stage("Jar Publish") {
            steps {
                script {
                        echo '<--------------- Jar Publish Started --------------->'
                         def server = Artifactory.newServer url:registry+"/artifactory" ,  credentialsId:"artifactory_token"
                         def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}";
                         def uploadSpec = """{
                              "files": [
                                {
                                  "pattern": "jarstaging/(*)",
                                  "target": "libs-release-local/{1}",
                                  "flat": "false",
                                  "props" : "${properties}",
                                  "exclusions": [ "*.sha1", "*.md5"]
                                }
                             ]
                         }"""
                         def buildInfo = server.upload(uploadSpec)
                         buildInfo.env.collect()
                         server.publishBuildInfo(buildInfo)
                         echo '<--------------- Jar Publish Ended --------------->'  
                
                }
            }   
        }   
    ```

Check-point: 
Ensure below are update
1. your jfrog account details in place of `https://valaxy01.jfrog.io` in the defination of registry `def registry = 'https://valaxy01.jfrog.io'`
2. Credentials id in the place of `jfrogforjenkins` in the  `def server = Artifactory.newServer url:registry+"/artifactory" ,  credentialsId:"artifactory_token"`
3. Maven repository name in the place of `libs-release-local` in the `"target": "ttrend-libs-release-local/{1}",`

### Build and publish a docker image 

1. Write and add dockerfile in the source code
	```sh
		FROM openjdk:8
		ADD jarstaging/com/valaxy/demo-workshop/2.0.2/demo-workshop-2.0.2.jar demo-workshop.jar
		ENTRYPOINT ["java", "-jar", "demo-workshop.jar"]
	```
   `Check-point:`  version number in pom.xml and dockerfile should match   
1. Create a docker repository in the Jfrog  
    repository name: valaxy-docker
1. Install `docker pipeline` plugin 

1. Update Jenkins file with the below stages  
    ```sh 
	   def imageName = 'valaxy01.jfrog.io/valaxy-docker/ttrend'
	   def version   = '2.0.2'
        stage(" Docker Build ") {
          steps {
            script {
               echo '<--------------- Docker Build Started --------------->'
               app = docker.build(imageName+":"+version)
               echo '<--------------- Docker Build Ends --------------->'
            }
          }
        }

                stage (" Docker Publish "){
            steps {
                script {
                   echo '<--------------- Docker Publish Started --------------->'  
                    docker.withRegistry(registry, 'artifactory_token'){
                        app.push()
                    }    
                   echo '<--------------- Docker Publish Ended --------------->'  
                }
            }
        }
    ```

Check-point: 
1. Provide jfrog repo URL in the place of `valaxy01.jfrog.io/valaxy-docker` in `def imageName = 'valaxy01.jfrog.io/valaxy-docker/ttrend'`  
2. Match version number in `def version   = '2.0.2'` with pom.xml version number  
3. Ensure you have updated credentials in the field of `artifactory_token` in `docker.withRegistry(registry, 'artifactory_token'){`

Note: make sure docker service is running on the slave system, and docker should have permissions to /var/run/docker.sock