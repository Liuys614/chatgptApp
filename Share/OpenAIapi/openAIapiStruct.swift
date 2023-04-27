//
//  openAIapiStruct.swift
//  chatgptApp
//
//  Created by Louis Liu on 2023/3/28.
//

import Foundation

enum Role{
    case user
    case assistant
}

/*{
 "model":"gpt-3.5-turbo",
 "messages":[{
    "role":"user",
    "content":"Hello!"}]
 }
*/
struct apiRequest: Codable{
    var model: String = ""
    var messages: [messageStruct] = [messageStruct]()
    var stream: Bool = false
    //var temperature: Float
}

/*
 {
   "id": "chatcmpl-123",
   "object": "chat.completion",
   "created": 1677652288,
   "choices": [{
     "index": 0,
     "message": {
       "role": "assistant",
       "content": "\n\nHello there, how may I assist you today?",
     },
     "finish_reason": "stop"
   }],
   "usage": {
     "prompt_tokens": 9,
     "completion_tokens": 12,
     "total_tokens": 21
   }
 }
 */
struct apiResponseStream: Decodable{
    var id: String
    var object: String
    var created: Int
    var choices: [choiceStream]
}

struct apiResponse: Decodable{
    var id: String
    var object: String
    var created: Int
    var choices: [choice]
    var usage: usageStruct
}

struct choice: Decodable{
    var index :Int
    var message : messageStruct
    var finish_reason: String
}

struct choiceStream: Decodable{
    var index :Int
    let delta: StreamMessage
    let finish_reason: String?
}

struct StreamMessage: Decodable{
    var role: String?
    var content: String?
}

struct messageStruct: Codable{
    var role: String
    var content: String
}

struct usageStruct: Codable{
    var prompt_tokens: Int
    var completion_tokens: Int
    var total_tokens: Int
}

/*
"error": {
  "message": "We could not parse the JSON body of your request. (HINT: This likely means you aren't using your HTTP library correctly. The OpenAI API expects a JSON payload, but what was sent was not valid JSON. If you have trouble figuring out how to fix this, please send an email to support@openai.com and include any relevant code you'd like help with.)",
  "type": "invalid_request_error",
  "param": null,
  "code": null
}
 */
struct ErrorRootResponse: Decodable{
    let error: ErrorResponse
}

struct ErrorResponse: Decodable{
    var message: String
    var type: String
    var param: String?
    var code: String?
}

