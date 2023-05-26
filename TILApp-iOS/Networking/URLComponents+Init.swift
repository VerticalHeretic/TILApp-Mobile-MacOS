//
//  URLComponents+Init.swift
//  TILApp-iOS
//
//  Created by Łukasz Stachnik on 26/05/2023.
//

import Foundation

public extension URLComponents {
    
    init(schema: String = "http",
         host: String = "127.0.0.1", // TODO: Probably could add some global configuration and change this on the fly with default value
         path: String,
         queryItems: [URLQueryItem]? = nil) {
        var components = URLComponents()
        components.scheme = schema
        components.host = host
        components.path = path
        components.queryItems = queryItems
        components.port = 8080
        self = components
    }
}
