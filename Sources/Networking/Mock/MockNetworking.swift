//
//  MockNetworking.swift
//  Networking
//
//  Created by Andrew Bernard on 3/23/25.
//
import Foundation

// MARK: - MockWebService
class MockNetworking: NetworkingProtocol {
    private let parser: Parser
    
    init(parser: Parser = Parser()) {
        self.parser = parser
    }
    
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        guard let endpoint = endpoint as? MockEndpoint else {
            throw NetworkError.endpointNotMocked
        }
        
        guard let data = endpoint.mockData() else {
            throw NetworkError.mockDataMissing
        }
        
        return try parser.json(data: data)
    }
    
    func requestGraphQL<T: Decodable>(_ endpoint: Endpoint, query: String, variables: [String: Any]?) async throws -> T {
        throw NetworkError.endpointNotMocked
    }
}
