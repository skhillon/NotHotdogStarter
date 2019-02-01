//
//  Client.swift
//  NotHotdogSolution
//
//  Created by Sarthak Khillon on 2/1/19.
//  Copyright © 2019 Sarthak Khillon. All rights reserved.
//

import Foundation
import SwiftyJSON // To parse JSON
import Alamofire // To launch and receive HTTP requests.

typealias HotdogHandler = ((Bool) -> Void)
typealias JSONHandler = ((JSON?) -> Void)

class Client {
    
    // TODO
    private static let GOOGLE_API_KEY = ""
    
    private static var path: URL {
        return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(GOOGLE_API_KEY)")!
    }
    
    static func classify(image: UIImage, completion: @escaping HotdogHandler) {
        let jsonData = createRequest(from: image.base64Encoding())
        
        request(method: .post, path: path, parameters: jsonData) { jsonResponse in
            guard let json = jsonResponse else {
                completion(false)
                return
            }
            
            completion(checkHotdog(from: json))
        }
    }
    
    private static func checkHotdog(from jsonData: JSON) -> Bool {
        // Extract labels array using SwiftyJSON
        if let labels = jsonData["labelAnnotations"].array {
            // If one of the labels contains the word "hotdog", then we have a hot dog!
            for label in labels {
                if let description = label["description"].string {
                    let modifiedDescription = description.lowercased().replacingOccurrences(of: " ", with: "")
                    
                    if modifiedDescription == "hotdog" {
                        return true
                    }
                }
            }
        }
        
        return false
    }
    
    
    private static func createRequest(from imageData: String) -> Parameters {
        return [
            "requests": [
                "image": [
                    "content": imageData
                ],
                "features": [
                    [
                        "type": "LABEL_DETECTION",
                        "maxResults": 10
                    ]
                ]
            ]
        ]
    }
    
    public static func request(method: HTTPMethod,
                               path: URL,
                               parameters: Parameters,
                               completion: @escaping JSONHandler) {
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "X-Ios-Bundle-Identifier": Bundle.main.bundleIdentifier ?? ""
        ]
        
        print("======== RAW URL =======")
        print(path.absoluteString)
        print("======== RAW PARAMS =======")
        print(parameters)
        
        Alamofire.request(path,
                          method: method,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: headers)
            //.validate()
            .responseJSON { (response) -> Void in
                print("======== RAW REQUEST BODY =======")
                print(response.request?.debugDescription as Any)
                print("======== RAW JSON RESPONSE =======")
                print(response.result.value as Any)
                switch response.result {
                case .success(let value):
                    completion(JSON(value))
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil)
                }
        }
    }
}
