//
//  DictionaryAPIHandler.swift
//  
//
//  Created by Sanjay Patil on 9/13/19.
//

import Foundation

enum OxfordDictEndpoint:String {
    case entriesEndpoint = "/entries/"
    case thesaurusEndpoint = "/thesaurus/"
}

enum APIError:Error {
    case lookupFailed
    case invalidWord
}

class DictionaryAPIHandler:NSObject, URLSessionDataDelegate {
    let appID:String
    let appKey:String
    let language = "en-gb"
    let oxfordDictBaseURL = "https://od-api.oxforddictionaries.com/api/v2"
    var receivedData = Data()
    var apiCompletionHandler:((String?, Error?) -> Void)?
    
    init(appID:String, appKey:String) {
        self.appID = appID
        self.appKey = appKey
    }
    
    func lookupWord(_ word:String, competionHandler:@escaping ((String?, Error?) -> Void)) {
        // store the completion handler.
        self.apiCompletionHandler = competionHandler
        let urlRequestString = oxfordDictBaseURL +
            OxfordDictEndpoint.entriesEndpoint.rawValue +
            language + "/" + word
        var urlRequest = URLRequest(url: URL(string: urlRequestString)!,
                                    cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad,
                                    timeoutInterval: 30)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue(self.appID, forHTTPHeaderField: "app_id")
        urlRequest.addValue(self.appKey, forHTTPHeaderField: "app_key")
        let configuration = URLSessionConfiguration.default
        if #available(OSX 10.13,iOS 11, *) {
            configuration.waitsForConnectivity = true
        } else {
            // Fallback on earlier versions
        }
        
        let session = URLSession(configuration: URLSessionConfiguration.default,
                                 delegate: self,
                                 delegateQueue: nil)
        let dataTask = session.dataTask(with: urlRequest)
        dataTask.resume()
    }
}

extension DictionaryAPIHandler {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if data.count > 0 {
            receivedData.append(data)
        }
    }
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        print("Received HTTP Response: \(response)")
        let httpResponse = response as! HTTPURLResponse
        guard httpResponse.statusCode == 200 else {
            completionHandler(.cancel)
            self.apiCompletionHandler!(nil, APIError.lookupFailed)
            return
        }
        completionHandler(.allow)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard error == nil else {
            print("Word lookup failed with error : \(error.debugDescription)")
            self.apiCompletionHandler!(nil, APIError.lookupFailed)
            return
        }
        // we received the whole data now so pass to the caller.
        let lookupResultString = String(data: self.receivedData, encoding: String.Encoding.utf8)
        self.apiCompletionHandler!(lookupResultString, nil)
    }
}
