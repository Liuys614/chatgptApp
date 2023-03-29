//
//  OpenAIAPI.swift
//  chatgptApp
//
//  Created by Yi-Shih Liu on 3/14/23.
//

import Foundation
/*
    curl https://api.openai.com/v1/chat/completions \
      -H 'Content-Type: application/json' \
      -H 'Authorization: Bearer YOUR_API_KEY' \
      -d '{
      "model": "gpt-3.5-turbo",
      "messages": [{"role": "user", "content": "Hello!"}]
    }'
*/


class client: ObservableObject{
    var model: String = "gpt-3.5-turbo"
    var temperature: Float = 0.8
    var role:String = "user"
    let tokenAuthScheme:String = "Bearer"
    let OPEN_API_KEY:String = ""
    let openAIUrl:String = "https://api.openai.com/v1/chat/completions"
    var header:Dictionary<String, String> {
        get {
           ["Authorization": tokenAuthScheme + " " + OPEN_API_KEY,
            "Content-Type": "application/json"]
        }
    }
    var req:URLRequest {
        let url = URL(string: openAIUrl)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        header.forEach{urlRequest.setValue($1, forHTTPHeaderField:$0)}
        return urlRequest
    }
    
    var callBack:(@MainActor(String, String)->Void)?
    
    var callBackStream:(@MainActor(String)->Void)?
    
    init(){
    }
    
    private func genBody(_ input:[(String,String)], _ stream:Bool = false) -> Data{
        var body: apiRequest = apiRequest()
        for (role,msg) in input{
            body.messages.append(
                messageStruct(role: role, content: msg))
        }
        body.model = model
        body.stream = stream
        return try! JSONEncoder().encode(body)
    }
    
    func sentMessageStream(_ input:[(String,String)]) async{
        var request = self.req
        request.httpBody = genBody(input, true)
        do{
            let (result, response) = try await URLSession.shared.bytes(for: request)
            
            
            // Check the response
            print(response as Any)
            guard let httpResponse = response as? HTTPURLResponse
            else {
                print("Invalid response")
                return
            }
            
            //(200...299).contains(httpResponse.statusCode)
            guard 200...299 ~= httpResponse.statusCode else {
                print("error reason")
                return
            }
            
            print(httpResponse.statusCode)
            
            print("data:")
            //print(response)
            do{
                for try await line in result.lines {
                    if line.hasPrefix("data: "){
                        guard let data = line.dropFirst(6).data(using: .utf8) else { return }
                        let apiRes = try JSONDecoder().decode(apiResponseStream.self, from: data)
                        print(apiRes)
                        if let finishReason:String = apiRes.choices.first?.finish_reason,
                           finishReason == "stop"{
                            return
                        }
                        guard let del:String = apiRes.choices.first?.delta.content else {continue}
                        DispatchQueue.main.async {
                            self.callBackStream!(del)
                        }
                    }
                }
            }
            catch{
                print(error)
            }
            
        } catch{
            print("Invalid response")
        }
    }
    
    // update message till all message is ready
    func sentMessage(_ input:[(String,String)]){
        var request = self.req
        request.httpBody = genBody(input)
        let task = URLSession.shared.dataTask(with: request) { [self] (data, response, error) in
            if let err = error {
                print("Error: \(err.localizedDescription)")
                return
            }
            
            // Check the response
            print(response as Any)
            guard let httpResponse = response as? HTTPURLResponse
            else {
                print("Invalid response")
                return
            }
            
            //(200...299).contains(httpResponse.statusCode)
            guard 200...299 ~= httpResponse.statusCode else {
                print("error reason")
                guard let httpData = data else{
                    return
                }
                let err = try? JSONDecoder().decode(ErrorRootResponse.self, from: httpData)
                print(err as Any)
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
                DispatchQueue.main.async {
                    self.callBack!("assistant", apiRes.choices[0].message.content)
                }
            }
            catch{
                print(error)
            }
        }
        
        task.resume()
    }
}
