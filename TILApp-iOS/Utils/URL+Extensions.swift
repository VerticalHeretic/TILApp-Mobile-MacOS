//
//  URL+Extensions.swift
//  TILApp-iOS
//
//  Created by Łukasz Stachnik on 04/06/2023.
//

import Foundation

extension URL {
    var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems else {
            return nil
        }
        
        var parameters = [String: String]()
        queryItems.forEach { item in
            parameters[item.name] = item.value
        }
        
        return parameters
    }
}
