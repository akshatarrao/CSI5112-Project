> • Discuss how you would enforce limiting users to only see their
> orders or orders that other users allowed them to see. 
> 
> • Present a guide of how someone would implement this in your project


# Introduction

## What is the Problem?

##  Why It is Important?

# Current Status 

# Possible Solutions

## Pre-Task: User authentication

### Proposed Solution  
user session management with cookies/local storage

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
