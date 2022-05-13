# Install and setup jenkins

	1. 	docker run -p 8080:8080 -p 50000:50000 -v C:/Users/pc/Documents/gh/git/HippoR6/jenkins_home:/var/jenkins_home jenkins/jenkins:lts
		Pull the jenkins long-term support (LTS) image form the docker hub. Jenkins will run on the default IP 8080 by default. We will map port 
		8080 on our machine to port 8080 on the container: -p 8080:8080. We can also map to a slave. One is created by default on 50000. Finally 
		we will make the jenkins config persistent by mapping the jenkins app data to a folder on the host. 
		
		This will pull in the docker image from remote. 
	   
	2. 	http://localhost:8080
		We can now access the jenkins controller from a web browser. A password will be displayed in the command prompt. Use this to login. 
	   
	3. 	Jenkins acts as the orchestrator between different plug-ins. It will dictate which plug-ins are installed, enabled, and how to hook the 
		I/O from one plug-in to another (if jenkins Pipeline is used). We will be using the pipeline feature for proof-of-concept, so, for now...
		Install the "Suggested Plugins". We can do this via a custom docker script for jenkins too if we need to launch it on different machines. 
		This will now install pipeline, git & ssh onto the machine. 
	   
	4. 	Manage Jenkins -> Manage Plugins or (http://localhost:8080/pluginManager/) -> Available -> Docker + Docker Commons + Docker Pipeline
		Lets install the Docker plugin for later.

	5. 	The jenkins controller now needs an agent to issue work to. A rule of thumb is to setup 1 agent per CPU. We will create a single agent 
		running on this machine. However, we are able to create a client on another cloud server in the future and set it as an agent. We will 
		connect to the agent from the master (from master to agent via ssh), but we can also do it the other way round. However, we will not 
		do either, so go ahead to step 6, nothing to do here!
	   
	6. 	Setup docker as a build agent. Yes, we can do this. Jenkins will build the "Dockerfile" in the root of the repository. This 
		image will become the context. We can point jenkins to a repository and setup a docker file in the root to use 
		as the jenkins container. This means we can use a configuration file to manage our build, test & run environment. To do this, Create 
		a new pipeline job, and attach the declarative pipeline configuration found in jenkins.pipeline at the repo root.
	   
	   