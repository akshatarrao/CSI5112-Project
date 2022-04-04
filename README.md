<h1 align="center">CSI 5112 Project: Software Engineering</h1>

<div align="center">
  <h4>
    <a href="https://github.com/AadityaOfficial/CSI5112-Project/stargazers"><img src="https://img.shields.io/github/stars/AadityaOfficial/CSI5112-Project.svg?style=plasticr"/></a>
    <a href="https://github.com/AadityaOfficial/CSI5112-Project/commits/master"><img src="https://img.shields.io/github/last-commit/AadityaOfficial/CSI5112-Project.svg?style=plasticr"/></a>
        <a href="https://github.com/AadityaOfficial/CSI5112-Project/commits/master"><img src="https://img.shields.io/github/commit-activity/y/AadityaOfficial/CSI5112-Project.svg?style=plasticr"/></a>
      <a href="https://codecov.io/gh/AadityaOfficial/CSI5112-Project">
        <img src="https://codecov.io/gh/AadityaOfficial/CSI5112-Project/branch/main/graph/badge.svg?token=6POY8CSRH7"/>
      </a>
    

  </h4>
</div>

<div align="center">
<a href="https://github.com/AadityaOfficial/CSI5112-Project/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=AadityaOfficial/CSI5112-Project" />
</a> </div>

<h2 align="center">Members : Akshata Ramesh Rao, Aaditya Suri, Songyu Wang, Prashant Kaushik, Andrew Clappison
  

  
  
  <br><br>
  
  
  
See [Frontend README](https://github.com/AadityaOfficial/CSI5112-Project/blob/development/frontend/README.md) for details
  
See [Backend README](https://github.com/akshatarrao/CSI5112-Project/blob/development/backend/README.md) for details


## CI

### build-pr.yml (Deprecated)
This workflow is created, so we can manually build backend service for debugging purpose

### docker-release.yml
Usually triggered by new release event. This workflow release docker images to the docker hub

See https://hub.docker.com/r/egrocsi5112/docker-repo/tags for the images

### dotnet_test.yml, flutter_test.yml, flutter_test_integration-marchant.yml, flutter_test_integration_buyer.yml
Those workflows are created to run all tests cases on every commit to ensure the quality of the project 

### ecs-release.yml
Usually triggered by new release event. Release new images to ECS for deployment

See https://application.egrotech.net/api/user (Replace "user" to access other endpoints) to access the backend server 

### release-flutter.yml
Usually triggered by new release event. Sync s3 frontend files for deployment

See https://applicationweb.egrotech.net/#/auth to access the frontend application

```callout {type: 'info', title: 'Note for Deployment'}
  Please note: It is possible that
 https://hub.docker.com/r/egrocsi5112/docker-repo/tags
 https://application.egrotech.net 
 https://applicationweb.egrotech.net are not functional due to stage 3 development.
If that is the case, please contact the team and we are happy to re-deploy the stage 2 version of the code upon request.
```
  

## Deployment 

<b>Public Docker Repository</b> : egrocsi5112/docker-repo<br>
<b>AWS Account Name</b> : Egro-CSI5112<br>
<b>AWS Account ID</b> : 014292004360<br>
<b>AWS Region</b>: US East (N. Virginia)us-east-1)<br>
<b>ECR Repository</b> : egro-csi5112<br>
<b>S3 Bucket</b> : egro-data-files<br>
<b>Route 53 domain</b> : egrotech.net<br>
<b>Cloud front distribution domain name</b> : https://d181w1uf7wk3a2.cloudfront.net<br>
<b>Public endpoint for Backend deployed on ECS</b> : https://application.egrotech.net/api/user<br>
<b>Public endpoint for Website deployed on Cloud front</b>:https://applicationweb.egrotech.net/#/auth<br>

## Database
  
  The database is hosted via `cloud.mongodb.com`
  See below for a preview of the database and data collection examples
  ![image](https://user-images.githubusercontent.com/98192648/161603379-ad367526-5979-4d62-9fc7-6ed9548d5e3d.png)
  
![image](https://user-images.githubusercontent.com/98192648/161603717-bb9f1c52-6198-45fe-9c44-14be4a94ef8b.png)
  ![image](https://user-images.githubusercontent.com/98192648/161603758-b46d95fd-20d9-4375-af36-6107d20ea3e6.png)
  ![image](https://user-images.githubusercontent.com/98192648/161603792-3b01256d-a6a0-4efe-b9ad-0a270d06bfab.png)
![image](https://user-images.githubusercontent.com/98192648/161603832-d7d33fed-8a9f-480f-8203-ff2deb13f1fe.png)
  ![image](https://user-images.githubusercontent.com/98192648/161603883-d4d74cec-aa70-4c8f-8385-990b195a228e.png)

 ### The indexes created for each collections and their justifications are described below
  Note: Realistically, no custom index is needed for this project. This section is forward looking in anticipate of larger data volumn, busier traffic and more out of scope features.    
  ![image](https://user-images.githubusercontent.com/98192648/161604120-b04f5eea-4f3e-40d2-9952-7cb1885dcbaa.png)
  ```
  id: Default index
  answer: This is used to insrease text search
  questionId: This is used to quickly query answers within the question socpe
  
  ```
  


