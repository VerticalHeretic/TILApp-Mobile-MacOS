//
//  URLSession+Client.swift
//  TILApp-iOS
//
//  Created by Łukasz Stachnik on 26/05/2023.
//

import Foundation

enum NetworkError: Error {
    case authenthicationError
    case notDefined(statusCode: Int)
    case nonHTTPResponse
}

public extension URLSession {
    
    func request<Response: Decodable>(for request: URLRequest) async throws -> Response {
        let (data, response) = try await self.data(for: request)
       
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.nonHTTPResponse
        }
        
        guard httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
            if httpResponse.statusCode == 401 {
                Auth.shared.logout()
                throw NetworkError.authenthicationError
            }
          
            throw NetworkError.notDefined(statusCode: httpResponse.statusCode)
        }
        
        let nonEmptyData = (data.isEmpty ? "{}".data(using: .utf8) : data) ?? Data()
        return try JSONDecoder.shared.decode(Response.self, from: nonEmptyData)
    }
}