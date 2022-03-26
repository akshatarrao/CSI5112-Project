> • Discuss how you would enforce limiting users to only see their
> orders or orders that other users allowed them to see. 
> 
> • Present a guide of how someone would implement this in your project


# Introduction

At the day May 25th, 2018, General Data Protection Regulation(GDPR) became applicable[1]. This European regulation restricted how a business can collect and use user data. Since the CSI5112-Project(the project) is designed to be used by public, it is important that the project respect the regulation, so it can be used in European markets. As of today, the project does not follow the industry best practices in order to protect user's privacy due to the scope and timeline limitation of the project. This document is created to discuss future possible design iterations to address this issue. 


# Current Status 

Currently, there are a few privacy related requirements in the project:
* The buyer shall view their own order history
* The merchant shall view all buyers' order history

The current implementation to control the above discussed requirements is:
```mermaid
sequenceDiagram
    participant frontend
    participant backend
    participant database
    frontend->>backend: User actions trigger API calls such as /orderhistory/{id}/?userID={userId}
    backend->>database: Lookup user permission based on the url query input and query data from the database
    database->>backend: Return stored data base on the input query
    backend->>frontend: Frontend read API response and display the data
```

This design has a major security defeat because the permission control solely relies on the `userID` input that can be easily manipulated. The following sections will discuss steps to resolve this security defeat. 

# Possible Solutions

## Pre-Task: User authentication

### Proposed Solution  
In order to maintain the current user information in the system and ensure this information cannot be maliciously manipulated, the user information needs to be communicated and stored in a secure and encrypted way instead of passing the user id directly in plain text. Currently, the industry standard is to use cookies to perform user session management. A simplified workflow is:
```mermaid
sequenceDiagram
    participant frontend
    participant backend
    frontend->>backend: A user attampts in via one type of authentication such as Basic auth, SSO, MFA, etc. 
    backend->>frontend: Validate user's credentials with database. If it is determined legit, generate, store a session token/identifier and send back to the frontend via `set-cookie` header. 
    frontend->>frontend: Store the return token as a cookie
    frontend->>backend: For all subsequent API requests, automaticlly attach the session token cookie
    backend->>backend: Read the seesion token value from the API request, find the corresponding user information, lookup user permission based on the said information and get data from the database.
    backend->>frontend: Return the data to frontend to display
```


### Implementation

### Alternative Consideration
Attach user auth in every call for server side auth directly. Bad idea since plain password local variable store


### Task 1: Define Scope of All READ Operations

### Proposed Solution 
pre-db Server side filter 
 use index, less compute, may skip query per business logic

### Implementation

### Alternative Consideration
post-db server side filter 

fe filter 


### Task 2: Error Headlining for Unauthorised READ Operations

### Proposed Solution 

return empty results 

tell use not Unauthorised and provide solution 

prevent user from do the op

### Implementation


## Additional Privacy Assurance Enhancement 

### Physical Isolation 
db per user

### Audit Logs
recover if bad thing happened 

### Grant Permission
allow users to view other users history


# Reference
[1] https://gdpr-info.eu/