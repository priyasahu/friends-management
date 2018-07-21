# Friends management
Friends Management is an api built with features like "Friend", "Unfriend", "Block", "Receive Updates" etc.

## Getting Started
 
### Prerequisites(if wanna run in local)
 
```
git
Ruby (version 2.5.0)
Rails (version 5.1.6)
```

**Clone the repo
 
```
git clone git@github.com:priyasahu/friends-management.git
```
 
**Install gems

```
bundle install
```
 
**Database migration

```
rails db:create
rails db:migrate
rake db:seed
```
 
**Now you may run a local server with
```
rails s
```

## The dummy users list are:
```
'andy@example.com'
'john@example.com'
'common@example.com'
'lisa@example.com'
'kate@example.com'
```
# This project is deployed in Heroku cloud -

**BASE_URL = https://boiling-thicket-86529.herokuapp.com/

#Custom Headers
```
Name  -  Content-Type
Value  -   application/json
``` 
Run CURL command to get the result - 

1. API to create a friend connection between two email addresses.
  ```
  curl -X POST -H 'Content-Type:application/json' -d '{"friends":["lisa@example.com","john@example.com"]}' https://boiling-thicket-86529.herokuapp.com/api/v1/friends
  endpoints: /api/v1/friends
  Method: POST
  request: {"friends":["john@example.com","kate@example.com"]}
  ```

2. API to retrieve the friends list for an email address.
  ```
  curl -X GET -H 'Content-Type:application/json' -d '{"email":"kate@example.com"}' http://boiling-thicket-86529.herokuapp.com/api/v1/friends
  endpoint: /api/v1/friends
  Method: GET
  ```

3. API to retrieve the common friends list between two email addresses.
  ```
curl -X GET -H 'Content-Type:application/json' -d '{"friends": ["john@example.com","kate@example.com"]}' http://boiling-thicket-86529.herokuapp.com/api/v1/common  endpoints: https://boiling-thicket-86529.herokuapp.com/api/v1/common 
  Method: POST
  request: {"friends": ["john@example.com","kate@example.com"]}
  ```

4. API to subscribe to updates from an email address.
  ```
  curl -X POST -H 'Content-Type:application/json' -d '{"requestor":"john@example.com", "target":"kate@example.com"}' http://boiling-thicket-86529.herokuapp.com/api/v1/subscribe
  endpoint: https://boiling-thicket-86529.herokuapp.com/api/v1/subscribe
  Method: POST
  request: {"requestor":"john@example.com","target":"kate@example.com"}
  ```

5. API to block updates from an email address.
  ```
  curl -X POST -H 'Content-Type:application/json' -d '{"requestor":"john@example.com", "target":"kate@example.com"}' http://boiling-thicket-86529.herokuapp.com/api/v1/block
  endpoints: https://boiling-thicket-86529.herokuapp.com/api/v1/block
  Method: POST
  request: { "requestor": "andy@example.com", "target": "john@example.com" }
  ```

6. API to retrieve all email addresses that can receive updates from an email address.
  ```
  curl -X POST -H 'Content-Type:application/json' -d '{"sender":"john@example.com","text":"hello"}' http://boiling-thicket-86529.herokuapp.com/api/v1/subscribers
  endpoint: https://boiling-thicket-86529.herokuapp.com/api/v1/subscribers
  Method: POST
  request: {"sender":"john@example.com","text":"Recieve updates"}
  ```
