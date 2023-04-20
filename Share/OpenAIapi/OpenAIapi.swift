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


class OpenAIAPIManager{
    var role:String = "user"
    private var model: String = "gpt-3.5-turbo"
    private var temperature: Float = 0.8
    private let tokenAuthScheme:String = "Bearer"
    private var OPEN_API_KEY:String = ""
    private let openAIUrl:String = "https://api.openai.com/v1/chat/completions"
    private var header:Dictionary<String, String> {
        get {
           ["Authorization": tokenAuthScheme + " " + OPEN_API_KEY,
            "Content-Type": "application/json"]
        }
    }
    private var req:URLRequest {
        let url = URL(string: openAIUrl)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        header.forEach{urlRequest.setValue($1, forHTTPHeaderField:$0)}
        return urlRequest
    }
    
    var sentStreamCompleteHandler:((String)async->Void)?
    
    var getTitleCompleteHandler:((String)async->Void)?
    
    var errorHandler:((String)async->Void)?
    
    func setAPIKey(_ key:String)->(){
        self.OPEN_API_KEY = key
    }
    
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
        guard let (result, response) = try? await URLSession.shared.bytes(for: request) else{
            print("[System Error]: url session error")
            return
        }
        
        // Check the response
        guard let httpResponse = response as? HTTPURLResponse else{
            guard let handleErr = self.errorHandler else{return}
            await handleErr("Invalid response")
            return
        }
        
        // check http statusCode
        guard (200...299).contains(httpResponse.statusCode) else{
            guard let handleErr = self.errorHandler else{
                print("[System Error]: stream complete handler is nil")
                return
            }
            var errorMsg = ""
            do{
                for try await line in result.lines {errorMsg += line}
            }catch{
                print(error.localizedDescription)
            }
            guard let apiRes = try? JSONDecoder().decode(ErrorRootResponse.self, from: Data(errorMsg.utf8))else{
                print("[System Error]: parssing JSON error \(errorMsg)")
                return
            }
            await handleErr("Http response: \(httpResponse.statusCode) \n \(apiRes.error.message))")
            return
        }
        
        // process AsyncBytes results received
        do{
            for try await line in result.lines {
                guard line.hasPrefix("data: "),
                      let data = line.dropFirst(6).data(using: .utf8),
                      let apiRes = try? JSONDecoder().decode(apiResponseStream.self, from: data) else{
                    print("[System Error]: parssing JSON error \(line)")
                    continue
                }
                
                // stop updating when steam finished
                if let finishReason = apiRes.choices.first?.finish_reason,
                   finishReason == "stop"{
                    return
                }
                
                // ignore if no content
                guard let del = apiRes.choices.first?.delta.content else{continue}
                
                // check callback function valid
                guard let handleStream = self.sentStreamCompleteHandler else {
                    print("[System Error]: stream complete handler is nil")
                    return
                }
                
                await handleStream(del)
            }
        } catch{
            print("[System Error]: \(error.localizedDescription)")
        }
    }
    
    func getTitle(_ input:[(String,String)]) async{
        var request = self.req
        var newInput = input
        newInput.append((role,"Make a title for this conversation, w/o quote, within 10 words, no Title: needed"))
        request.httpBody = genBody(newInput, false)
        guard let (data, response) = try? await URLSession.shared.data(for: request) else{
            print("[System Error]: url session error")
            return
        }
        
        // Check the response
        guard let httpResponse = response as? HTTPURLResponse else{
            guard let handleErr = self.errorHandler else{return}
            await handleErr("[System Error]: Invalid response")
            return
        }
        
        // check http statusCode
        guard (200...299).contains(httpResponse.statusCode) else{
            let err = try? JSONDecoder().decode(ErrorRootResponse.self, from: data)
            print(err?.error.message as Any)
            return
        }
        
        do{
            let apiRes = try JSONDecoder().decode(apiResponse.self, from: data)
            
            // check callback function valid
            guard let handleStream = self.getTitleCompleteHandler else {
                print("[System Error]: gettitle Complete handler is nil")
                return
            }
            
            await handleStream(apiRes.choices[0].message.content)
        }catch{
            print(error)
        }
    }
}
