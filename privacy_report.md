> • Discuss how you would enforce limiting users to only see their
> orders or orders that other users allowed them to see. 
> 
> • Present a guide of how someone would implement this in your project


# Introduction

At the day May 25th, 2018, [General Data Protection Regulation(GDPR)](https://gdpr-info.eu/) became applicable. This European regulation restricted how a business can collect and use user data. Since the CSI5112-Project(the project) is designed to be used by public, it is important that the project respect the regulation, so it can be used in European markets. As of today, the project does not follow the industry best practices in order to protect user's privacy due to the scope and timeline limitation of the project. This document is created to discuss future possible design iterations to address this issue. 


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

## Task 1: User Authentication and Session Management

### Proposed Solution  
In order to maintain the current user information in the system and ensure this information cannot be maliciously manipulated, the user information needs to be communicated and stored in a secure and encrypted way instead of passing the user id directly in plain text. Currently, the industry standard is to use cookies to perform user session management. A simplified workflow is:
```mermaid
sequenceDiagram
    participant frontend
    participant backend
    frontend->>backend: A user attampts to login via one type of authentications such as Basic auth, SSO, MFA, etc
    backend->>frontend: Validate user's credentials with database. If it is determined legit, generate, store a session token/identifier and send back to the frontend via `set-cookie` header (or other agreed formats)
    frontend->>frontend: Store the return token as a cookie
    frontend->>backend: For all subsequent API requests, automaticlly attach the session token cookie
    backend->>backend: Read the seesion token value from the API request, find the corresponding user information, lookup user permission based on the said information and get data from the database
    backend->>frontend: Return the data to frontend to display
```

In this workflow, user information is read-only. The ability to set the current user in a given session never left the backend. Only one session token/identifier (a randomly generated meaningless string) is communicated between frontend and backend. With this approach, user information is maintained and managed via a "placeholder" and the said "placeholder" is hard to manipulate while maintaining its validation. 

### Implementation

ASP.NET Core has a built-in [session management package](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/app-state?view=aspnetcore-6.0). The developer can follow the tutorial to enable the session management for the project. 

On the frontend side, [flutter_session](https://pub.dev/packages/flutter_session) package is available. It allows developers to store and retrieve any string (session cookie in this use case) globally.

Once the system is ready to utilize session management, the developer can implement the following pseudocode:
```python
# Setup backend session
def login(request):
    auth = request.auth
    if not validate(auth):
        raise AuthError()
    user = find_user_via_auth(auth)
    session.add(user)
    return api_ok(session.cookie)

# Setup frontend session
def login(auth):
    res = send_api_request(auth)
    set_cookie(res.cookie.session)
    

# Use backend session
def search_order_history(request):
    session = request.cookie.session
    if not validate(session):
        raise AuthError()
    user = find_user_via_session(session)
    order_history = send_db_query(user.permission)
    return api_ok(order_histroy)

# Use frontend session
def display_order_history():
    res = send_api_request_search_order_history(cookie.session)
    display(res.order_histroy_data)
```



### Alternative Consideration

#### Attach user auth to every API requests

An alternative approach is to consider all API requests from the frontend independent. For every request originated from frontend, a basic auth (or other type of one-step authentication method) is attached to the request. Once the backend receives the request, it validates the authentication and compute the value. 

Due to the following shortcoming, this approach is abandoned:
* It is unrealistic to implement MFA or SSO since those authentication approaches require user actions.
* Since it is unrealistic to ask user to input the authentication for every request the project may make in real time, the authentication has to be stored somewhere locally which can be looked up by malicious actors or software programs.
* It may reduce the request turn around time due to the extra authentication computation on the backend side. 


### Task 2: Define Scope of All READ Operations

### Proposed Solution 



pre-db Server side filter 
 use index, less compute, may skip query per business logic

### Implementation

### Alternative Consideration
post-db server side filter 

fe filter 


### Task 3: Error Headlining for Unauthorised READ Operations

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

