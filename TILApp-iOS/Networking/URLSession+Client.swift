//
//  URLSession+Client.swift
//  TILApp-iOS
//
//  Created by Łukasz Stachnik on 26/05/2023.
//

import Foundation

public extension URLSession {
    
    func request<Response: Decodable>(for request: URLRequest) async throws -> Response {
        let (data, response) = try await self.data(for: request) // TODO: Handle the response codes somehow :)
        
        return try JSONDecoder.shared.decode(Response.self, from: data)
    }
}
