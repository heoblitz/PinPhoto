//
//  Network.swift
//  PinPhoto
//
//  Created by heo on 2020/12/21.
//  Copyright © 2020 won heo. All rights reserved.
//

import Foundation

class Api {
    static let shared = Api()
    
    private let base: String = "https://api.unsplash.com/"
    private let random: String = "photos/random/"
    private let search: String = "search/photos"
    
    func request(for query: String?, resultHandler: @escaping ([Unsplash]) -> ()) {
        
        var component = URLComponents(string: base + search)
        
        component?.queryItems = [
            URLQueryItem(name: "count", value: "20"),
            URLQueryItem(name: "content_filter", value: "high"),
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "client_id", value: ApiKey.access)
        ]
        
        guard let url = component?.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // request.setValue(ApiKey.auth, forHTTPHeaderField: "Authorization")
                        
        URLSession.shared.dataTask(with: request) { (data: Data?, reponse: URLResponse?, error: Error?) in
            guard error == nil else {
                
                return
            }
            
            if let data = data {
                do {
                    let result: Search = try JSONDecoder().decode(Search.self, from: data)
                    let unsplashes: [Unsplash] = result.unsplashes
                    resultHandler(unsplashes)
                } catch let error {
                    print(error)
                }
            }
        }.resume()
    }
}
