//
//  OpenAIAPI.swift
//  chatgptApp
//
//  Created by Yi-Shih Liu on 3/14/23.
//

import Foundation
let OPEN_API_KEY = "Bearer "//fill in api here to fix compile error
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
struct apiResponse: Codable{
    var id: String
    var object: String
    var created: Int
    var choices: [choice]
    var usage: usageStruct
}

struct choice: Codable{
    var index :Int
    var message : messageStruct
    var finish_reason: String
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
struct rspError: Codable{
    var message: String
    var type: String
    var param: String
    var code: String
}
/*
    curl https://api.openai.com/v1/chat/completions \
      -H 'Content-Type: application/json' \
      -H 'Authorization: Bearer YOUR_API_KEY' \
      -d '{
      "model": "gpt-3.5-turbo",
      "messages": [{"role": "user", "content": "Hello!"}]
    }'
*/
func postOpenAIRequest(){
    guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else { return }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(OPEN_API_KEY, forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = "{\"model\":\"gpt-3.5-turbo\",\"messages\":[{\"role\":\"user\",\"content\":\"Hello!\"}]}".data(using: .utf8)
    print(request.httpMethod as Any)
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let err = error {
                print("Error: \(err.localizedDescription)")
                return
        }
        
        // Check the response
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode)
        else {
            print("Invalid response")
            return
        }
        
        print(httpResponse.statusCode)
        
        // Check the data
        guard let data = data else {
            print("No data received")
            return
        }
        
        print("data:")
        print(data)
        do{
            let apiRes = try JSONDecoder().decode(apiResponse.self, from: data)
            print(apiRes)
        }
        catch{
            print(error)
        }
    }
    task.resume()
    
}
