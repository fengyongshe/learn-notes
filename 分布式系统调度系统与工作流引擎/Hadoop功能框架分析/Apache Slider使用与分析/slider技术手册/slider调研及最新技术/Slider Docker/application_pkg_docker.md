<!---
   Licensed to the Apache Software Foundation (ASF) under one or more
   contributor license agreements.  See the NOTICE file distributed with
   this work for additional information regarding copyright ownership.
   The ASF licenses this file to You under the Apache License, Version 2.0
   (the "License"); you may not use this file except in compliance with
   the License.  You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
-->

# Apache Slider Docker Based Application Packaging Support (Tech Preview)

##Introduction

Docker is an open platform for developers and sysadmins to build, ship, and run distributed applications.

- Users can use their existing Docker images without any modifications.
- They need to create configuration files according to Slider's template for Docker based applications
- Slider can deploy their Docker containers within YARN cluster, with resource management capability from YARN
- They can use Slider to monitor and manage their Docker containers/applications

## Terminology

### Docker Image
- Applications definition file
- Is composed of one or multiple layers
- Users create Docker containers out of Docker images

### Docker Container
- A running instance of a Docker image
- Comprises the application and its dependencies
- Enjoys the resource isolation and allocation benefits of VMs but is much more portable and efficient.

##Specifications

Refer to [*What is Docker*](https://www.docker.com/whatisdocker/) for a quick overview of Docker and why it excels VM.

**Goal**

- Slider shall be able to deploy an application defined as Docker image, monitor its running status, fetch exported configs, and maintain its lifecycle
- Users can use their existing Docker images without any modifications
- Slider shall be able to pull Docker images from Docker Hubs
- Slider shall be able to aggregate application logs from and feed in input files into Docker containers
- Slider shall be able to launch applications containing multiple Docker images, as well as maintaining multiple Docker containers on the same physical host
- Users shall be able to specify the Docker images, configurations and if necessary, the special docker command to start/query/stop the container in Slider configuration files
- Slider shall be able to deploy security credentials into the container if the application is running in secure mode

**The scope of this JIRA doesn’t yet include**

- Application Docker containers integrated with Ambari client
- Applications deployed in secure mode
- Running application Docker containers in OS other than Linux
- Docker images stored in private Docker hub - we would leave this work to administrators to configure Docker daemon to be able to pull from those hubs
- Application Docker containers started with `docker run -i` option which requires interaction with the user
- Docker images that require multiple initialization steps, more than just one `docker run`
- YARN can only monitor resources consumed by SliderAgent, instead of that of the Docker containers

**Commands to run**

    slider create [app-name] --template appConfig.json --metainfo metainfo.json --resources resources.json

Below is an example of how we can use Slider to deploy a multi-component Dockerized application

**metainfo.json**

    {
    "schemaVersion": "2.1",
    "application": {
            "name": "NODEJS-REDIS",
            "components": [
                {
                    "name": "NODEJS",
                    "type": "docker",
                    "dockerContainers": [
                        {
                            "name": "nodejs",
                            "commandPath": "/usr/bin/docker",
                            "image": "rsahahw/centos-node-redis",
                            "ports": [{
                                    "containerPort" : "8000"
                                
                            }]
                        }
                    ]
                },
                {
                    "name": "REDIS",
                    "type": "docker",
                    "dockerContainers": [
                    {
                            "name": "redis",
                            "commandPath": "/usr/bin/docker",
                            "image": "tutum/redis",
                            "ports": [{
                                    "containerPort" : "6379",
                                    "hostPort": "6379"
                                
                            }]
                        
                    }]
                }

            ]
        }

	}


Metainfo.json is the specification about how your image should run. All fields in the config file are not different than those in a non Docker application, except for those under "dockerContainers". All fields under "dockerContainers" are required unless specified "optional" and they described as below:

- **name**: Name of your container. It doesn't affect how you launch your application, but Slider will use it to identify the overriding value in appConfig.json as shown later
- **image**: The full name of you Docker image.
- **additionalParam**: (optional) Additional params that need to be passed to the command to be invoked during starting your Docker container
- **commandPath**: The path to your docker command
- **statusCommand**: (optional) The command you can specify to check the health of your running application. Slider relies on the return value of the command to judge if healthy. 0 as healthy and non-0 as unhealthy. If not provided, Slider will execute "docker top ${CONTAINER_ID} | grep"
- **port, containerPort and hostPort**: (optional) the port of the container that will be binded to the hostPort field, which will be translated into `-p hostPort:containerPort` when starting the container with `docker run`
- **mount, containerMount and hostMount**: (optional) the directories from the host that will be mounted into the container, which will be translated into ‘-v hostMount:containerMount’ when starting the container
- **options**: (optional) allow users to specify any additional docker run command options to use. Those will be passed to 'docker run' command when starting your application. If not specified, "-d" will be used

Please note configs specified in metainfo.json can be overridden in appConfig.json: **commandPath, options, statusCommand, inputFiles, mounts, ports**

**appConfig.json**

    {
  		"schema": "http://example.org/specification/v2.0.0",
  		"metadata": {
  		},
  		"global": {
  		},
  		"components": {
        		"NODEJS": {
        		    "nodejs.commandPath": "/user/local/bin/docker", 
        			"nodejs.options":"-d -e REDIS_HOST=${REDIS_HOST} --net=host",
   					"nodejs.statusCommand":"docker inspect -f {{.State.Running}} ${CONTAINER_ID} | grep true"
        		},
        		"REDIS": {
           			"redis.options":"-d -e REDIS_PASS=**None**",
		  		    "redis.statusCommand":"docker top ${CONTAINER_ID} | grep redis-server"
        		}
 		}
	}



AppConfig.json is where you can provide overriding config value for those you defined in metainfo.json. This may be needed when you want to provide some runtime variance.

Please note that you need to specify the container name before your config key: "nodejs.commandPath" instead of "commandPath". This is to distinguish different containers under the same component as defined in metainfo.json

In this example, we are specifying a different docker command path than the default `/usr/bin/docker` in metainfo.json and a different set of options that we need to include in the `docker run` command. 

The config structure in appConfig.json(map) -> components(list) -> component(map) -> containers(list)-> container(map) have to match the one in metainfo.json. 

**resources.json**

    {
        "schema": "http://example.org/specification/v2.0.0", 
        "metadata": { }, 
        "global": { }, 
        "components": {
            "slider-appmaster": { }, 
            "REDIS": {
                "yarn.role.priority": "1", 
                "yarn.component.instances": "1", 
                "yarn.memory": "512"
            }, 
            "NODEJS": {
                "yarn.role.priority": "2", 
                "yarn.component.instances": "1", 
                "yarn.memory": "512"
            }
        }
    }


With the configuration files above, Slider will ask for the required number of containers from YARN, as specified in resources.json. In each of those YARN containers, Slider will run `docker pull` to download the Docker image specified in metainfo.json. In the scope of this JIRA ticket, we are not supporting Docker images stored in private Docker hubs that require credentials to run docker pull. After downloading completes, Slider will start the containers by running, in this case, `/usr/bin/docker run -d borja/memcached`

- For redis components, it will run:

`docker run -d -e REDIS_PASS=**None** -p hostPort:containerPort -name ${CONTAINER_ID} tutum/redis`

- For nodejs components, it will run:

`docker run -d -e REDIS_HOST=${REDIS_HOST} -name ${CONTAINER_ID} --net=host rsahahw/centos-node-redis`

