# Clima

## Description 
Clima is a basic weather app that uses the open weather map api to get current weather conditions for queried city. https://openweathermap.org/
Clima follows the Model View Controller Design pattern. 

## What I Learned 
### Networking with vanilla swift  
  - Create a URL from a string 
  - Create a URL Session 
  - Give a session a task 
  - Parse JSON Payload if task returns a successful payload
### Decodable Protocol 
  - Required to convert a external representation in my case the JSON payload into a swift type im my case the weather data struct
### Delegates
  - Required to modify UI Child UI views from the view controller 
  - Design pattern used to decouple 
### Protocols 
  - Necessary to implement the delegate pattern on our own types 
### String Manipulation 
  - Remove leading, trailing and excess whitespace from user input string representing the city query.

### How to improve 
- Handle ambiguity between cities with same Name for example Lancaster, CA or Lancaster PA ?


